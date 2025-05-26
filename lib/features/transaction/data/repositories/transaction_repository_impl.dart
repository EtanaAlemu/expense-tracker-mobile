import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:expense_tracker/features/transaction/data/local/transaction_local_data_source.dart';
import 'package:expense_tracker/features/transaction/data/mappers/transaction_mapper.dart';
import 'package:expense_tracker/features/transaction/data/remote/transaction_remote_data_source.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _localDataSource;
  final TransactionRemoteDataSource _remoteDataSource;
  final TransactionMapper _mapper;
  final NetworkInfo _networkInfo;

  TransactionRepositoryImpl({
    required TransactionLocalDataSource localDataSource,
    required TransactionRemoteDataSource remoteDataSource,
    required TransactionMapper mapper,
    required NetworkInfo networkInfo,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _mapper = mapper,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(
      String userId) async {
    try {
      // First get and return local data immediately
      final localResult = await getLocalTransactions();
      List<Transaction> transactions = [];

      localResult.fold(
        (failure) {
          return null;
        },
        (localTransactions) {
          transactions = localTransactions
              .where((transaction) =>
                  transaction.userId == userId &&
                  !transaction.isDeleted &&
                  transaction.id
                      .isNotEmpty) // Filter out deleted and empty ID transactions
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
          return null;
        },
      );

      // Start loading remote data in the background
      if (await _networkInfo.isConnected) {
        getRemoteTransactions().then((remoteResult) async {
          await remoteResult.fold(
            (failure) async {
              return null;
            },
            (remoteTransactions) async {
              // Create a map of existing transactions by ID for quick lookup
              final existingTransactionsById = {
                for (var transaction in transactions)
                  transaction.id: transaction
              };

              // Only add new transactions that don't exist locally and aren't deleted
              for (var remote in remoteTransactions) {
                if (!existingTransactionsById.containsKey(remote.id) &&
                    !remote.isDeleted &&
                    remote.id.isNotEmpty) {
                  // Filter out empty ID transactions
                  transactions.add(remote);
                  await cacheTransaction(remote);
                }
              }

              // Re-sort the list after adding new transactions
              transactions.sort((a, b) => b.date.compareTo(a.date));
            },
          );
        });
      }

      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Transaction>>> getLocalTransactions() async {
    try {
      final hiveModels = await _localDataSource.getAll();
      final transactions =
          hiveModels.map((model) => _mapper.toEntity(model)).toList();
      return Right(transactions);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Transaction>>> getRemoteTransactions() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final remoteTransactions = await _remoteDataSource.getTransactions();
      return Right(remoteTransactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> addTransaction(
      Transaction transaction) async {
    try {
      print('➕ Adding transaction');

      // Create a local ID using timestamp if not provided
      final localId = transaction.id.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : transaction.id;

      if (await _networkInfo.isConnected) {
        print('🌐 Online - adding to remote server first');
        try {
          // Try to add to remote server first
          final remoteTransaction = await _remoteDataSource.addTransaction(
            transaction.copyWith(id: localId),
          );
          print('✅ Successfully added to remote server');

          // Save locally with remote ID and synced status
          final syncedTransaction = transaction.copyWith(
            id: remoteTransaction.id,
            isSynced: true,
          );
          await _localDataSource.save(_mapper.toHiveModel(syncedTransaction));
          print('✅ Saved to local storage with remote ID');

          return Right(syncedTransaction);
        } catch (e) {
          print('⚠️ Failed to add to remote server: $e');
          // Fall back to offline mode
          print('📱 Falling back to offline mode');
        }
      }

      // Offline mode or remote add failed
      print('📱 Offline mode - saving locally only');
      final localTransaction = transaction.copyWith(
        id: localId,
        isSynced: false,
      );
      await _localDataSource.save(_mapper.toHiveModel(localTransaction));
      print('✅ Saved to local storage with local ID');

      return Right(localTransaction);
    } catch (e) {
      print('❌ Error in addTransaction: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
      Transaction transaction) async {
    try {
      print('🔄 Updating transaction: ${transaction.id}');
      print(
          '📊 Transaction sync status: isSynced=${transaction.isSynced}, isUpdated=${transaction.isUpdated}');

      // First update locally
      final hiveModel = _mapper.toHiveModel(transaction);
      await _localDataSource.update(hiveModel);
      print('✅ Updated in local storage');

      if (await _networkInfo.isConnected) {
        print('🌐 Online - attempting to update remote server');
        try {
          // Try to update remote server
          await _remoteDataSource.updateTransaction(transaction);
          print('✅ Successfully updated on remote server');

          // Update local transaction with sync status
          final updatedTransaction = transaction.copyWith(
            isSynced: true,
            isUpdated: false, // Reset update flag since it's synced
          );
          await _localDataSource
              .update(_mapper.toHiveModel(updatedTransaction));
          print('✅ Updated sync status in local storage');
          return Right(updatedTransaction);
        } catch (e) {
          print('⚠️ Failed to update on remote server: $e');
          // Mark as unsynced and updated for future sync
          final unsyncedTransaction = transaction.copyWith(
            isSynced: true, // Keep as synced since it was online-created
            isUpdated: true, // Mark as updated since it needs sync
          );
          await _localDataSource
              .update(_mapper.toHiveModel(unsyncedTransaction));
          print('✅ Marked as updated for future sync');
          return Right(unsyncedTransaction);
        }
      } else {
        print('📡 Offline - checking transaction sync status');
        if (!transaction.isSynced) {
          print('📝 Transaction was created offline - updating locally only');
          // If transaction was created offline, update locally only
          final localTransaction = transaction.copyWith(
            isSynced: false,
            isUpdated:
                false, // No need to mark as updated since it's offline-created
          );
          await _localDataSource.update(_mapper.toHiveModel(localTransaction));
          print('✅ Updated locally only (will be synced as new when online)');
          return Right(localTransaction);
        } else {
          print(
              '📝 Transaction was synced before - marking as updated for future sync');
          // If transaction was synced before, mark as updated for future sync
          final updatedTransaction = transaction.copyWith(
            isSynced: true, // Keep as synced since it was online-created
            isUpdated: true, // Mark as updated for future sync
          );
          await _localDataSource
              .update(_mapper.toHiveModel(updatedTransaction));
          print('✅ Marked as updated for future sync');
          return Right(updatedTransaction);
        }
      }
    } catch (e) {
      print('❌ Error in updateTransaction: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(
      Transaction transaction) async {
    try {
      print('🗑️ Deleting transaction: ${transaction.id}');
      print(
          '📊 Transaction sync status: isSynced=${transaction.isSynced}, isDeleted=${transaction.isDeleted}');

      if (await _networkInfo.isConnected) {
        print('🌐 Online - attempting to delete from both local and remote');
        try {
          // Try to delete from remote first
          await _remoteDataSource.deleteTransaction(transaction.id);
          print('✅ Successfully deleted from remote server');
        } catch (e) {
          print('⚠️ Failed to delete from remote server: $e');
          // Mark as deleted locally even if remote deletion fails
          final deletedTransaction = transaction.copyWith(
            isDeleted: true,
          );

          // Update the local transaction with the deleted status
          await _localDataSource
              .update(_mapper.toHiveModel(deletedTransaction));
          print('✅ Marked as deleted locally for future sync');

          return const Right(null);
        }

        // If remote deletion was successful, delete from local storage
        try {
          final hiveModel = _mapper.toHiveModel(transaction);
          await _localDataSource.delete(hiveModel);
          print('✅ Successfully deleted from local storage');
        } catch (e) {
          print('⚠️ Failed to delete from local storage: $e');
          // If local deletion fails, mark as deleted for future sync
          final deletedTransaction = transaction.copyWith(
            isDeleted: true,
          );
          await _localDataSource
              .update(_mapper.toHiveModel(deletedTransaction));
          print('✅ Marked as deleted locally for future sync');
        }
      } else {
        print('📡 Offline - checking transaction sync status');
        if (!transaction.isSynced) {
          print(
              '📝 Transaction was created offline - deleting completely from local storage');
          // If transaction was created offline, delete it completely
          final hiveModel = _mapper.toHiveModel(transaction);
          await _localDataSource.delete(hiveModel);
          print(
              '✅ Successfully deleted offline-created transaction from local storage');
        } else {
          print('📝 Transaction was synced before - marking for deletion');
          // If transaction was synced before, mark as deleted for future sync
          final deletedTransaction = transaction.copyWith(
            isDeleted: true,
          );
          await _localDataSource
              .update(_mapper.toHiveModel(deletedTransaction));
          print('✅ Marked as deleted locally for future sync');
        }
      }

      return const Right(null);
    } catch (e) {
      print('❌ Error in deleteTransaction: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
      String type, String userId) async {
    try {
      // First try local
      final hiveModels = await _localDataSource.getAll();
      final localTransactions = hiveModels
          .map(_mapper.toEntity)
          .where((transaction) =>
              transaction.type == type &&
              transaction.userId == userId &&
              !transaction.isDeleted &&
              transaction.id
                  .isNotEmpty) // Filter out deleted and empty ID transactions
          .toList();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions);
      }

      // Then try remote if we have internet
      if (await _networkInfo.isConnected) {
        final remoteTransactions =
            await _remoteDataSource.getTransactionsByType(type);
        final filteredRemoteTransactions = remoteTransactions
            .where((transaction) =>
                !transaction.isDeleted &&
                transaction.id
                    .isNotEmpty) // Filter out deleted and empty ID transactions
            .toList();
        if (filteredRemoteTransactions.isNotEmpty) {
          await cacheTransactions(filteredRemoteTransactions);
        }
        return Right(filteredRemoteTransactions);
      }

      return Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
      String categoryId, String userId) async {
    try {
      print(
          '🔍 Checking transactions for category: $categoryId, user: $userId');

      // First try local
      print('📱 Checking local transactions...');
      final hiveModels = await _localDataSource.getAll();
      final localTransactions = hiveModels
          .map(_mapper.toEntity)
          .where((transaction) =>
              transaction.categoryId == categoryId &&
              transaction.userId == userId &&
              !transaction.isDeleted &&
              transaction.id
                  .isNotEmpty) // Filter out deleted and empty ID transactions
          .toList();
      print('📊 Found ${localTransactions.length} local transactions');

      // Then try remote if we have internet
      if (await _networkInfo.isConnected) {
        print('🌐 Internet available, checking remote transactions...');
        try {
          final remoteTransactions =
              await _remoteDataSource.getTransactionsByCategory(categoryId);
          print('📊 Found ${remoteTransactions.length} remote transactions');

          // Filter remote transactions by user ID, category ID, and not deleted
          final filteredRemoteTransactions = remoteTransactions
              .where((transaction) =>
                  transaction.userId == userId &&
                  transaction.categoryId == categoryId &&
                  !transaction.isDeleted &&
                  transaction.id
                      .isNotEmpty) // Filter out deleted and empty ID transactions
              .toList();
          print(
              '📊 Found ${filteredRemoteTransactions.length} remote transactions for user and category');

          print('💾 Caching remote transactions...');
          await cacheTransactions(filteredRemoteTransactions);
          // Merge local and remote transactions, removing duplicates
          final allTransactions =
              {...localTransactions, ...filteredRemoteTransactions}.toList();
          print(
              '📊 Total unique transactions after merge: ${allTransactions.length}');
          return Right(allTransactions);
        } catch (e) {
          print('⚠️ Failed to get remote transactions: $e');
          // If remote fails, continue with local data
        }
      } else {
        print('📡 No internet connection, using local data only');
      }

      // Return local transactions if no remote data or remote failed
      print('✅ Returning ${localTransactions.length} local transactions');
      return Right(localTransactions);
    } catch (e) {
      print('❌ Error in getTransactionsByCategory: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    try {
      // First try local
      final hiveModels = await _localDataSource.getAll();
      final localTransactions = hiveModels
          .map(_mapper.toEntity)
          .where((transaction) =>
              transaction.date.isAfter(startDate) &&
              transaction.date.isBefore(endDate) &&
              transaction.userId == userId &&
              !transaction.isDeleted &&
              transaction.id
                  .isNotEmpty) // Filter out deleted and empty ID transactions
          .toList();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions);
      }

      // Then try remote if we have internet
      if (await _networkInfo.isConnected) {
        final remoteTransactions = await _remoteDataSource
            .getTransactionsByDateRange(startDate, endDate);
        final filteredRemoteTransactions = remoteTransactions
            .where((transaction) =>
                !transaction.isDeleted &&
                transaction.id
                    .isNotEmpty) // Filter out deleted and empty ID transactions
            .toList();
        if (filteredRemoteTransactions.isNotEmpty) {
          await cacheTransactions(filteredRemoteTransactions);
        }
        return Right(filteredRemoteTransactions);
      }

      return Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalTransactionsByType(
      String type, String userId) async {
    try {
      final result = await getTransactionsByType(type, userId);
      return result.fold(
        (failure) => Left(failure),
        (transactions) => Right(
          transactions.fold<double>(
            0.0,
            (sum, transaction) => sum + transaction.amount,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalTransactionsByCategory(
      String categoryId, String userId) async {
    try {
      final result = await getTransactionsByCategory(categoryId, userId);
      return result.fold(
        (failure) => Left(failure),
        (transactions) => Right(
          transactions.fold<double>(
            0.0,
            (sum, transaction) => sum + transaction.amount,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
    String userId,
  ) async {
    try {
      final result =
          await getTransactionsByDateRange(startDate, endDate, userId);
      return result.fold(
        (failure) => Left(failure),
        (transactions) => Right(
          transactions.fold<double>(
            0.0,
            (sum, transaction) => sum + transaction.amount,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> cacheTransaction(
      Transaction transaction) async {
    try {
      final hiveModel = _mapper.toHiveModel(transaction);
      await _localDataSource.save(hiveModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> cacheTransactions(
      List<Transaction> transactions) async {
    try {
      final hiveModels = transactions.map(_mapper.toHiveModel).toList();
      await _localDataSource.saveAll(hiveModels);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncTransactions() async {
    try {

      // Get all local transactions
      final localResult = await getLocalTransactions();
      if (localResult.isLeft()) {
        return Left(CacheFailure('Failed to get local transactions'));
      }

      final localTransactions = localResult.getOrElse(() => []);

      // Filter transactions that need syncing
      final unsyncedTransactions = localTransactions
          .where((transaction) =>
              (!transaction.isSynced && !transaction.isDeleted) ||
              (transaction.isUpdated && !transaction.isDeleted))
          .toList();

      // Filter transactions marked for deletion
      final deletedTransactions = localTransactions
          .where(
              (transaction) => (transaction.isSynced && transaction.isDeleted))
          .toList();

      if (unsyncedTransactions.isEmpty && deletedTransactions.isEmpty) {
        return const Right(null);
      }

      // Check internet connection
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection'));
      }

      // First handle deleted transactions
      for (final transaction in deletedTransactions) {
        try {

          // Delete from remote server
          await _remoteDataSource.deleteTransaction(transaction.id);


          // Now remove from local storage
          await _localDataSource.delete(transaction.id);
        } catch (e) {
          // Continue with next transaction even if one fails
          continue;
        }
      }

      // Then handle unsynced/updated transactions (excluding any that were just deleted)
      final remainingUnsynced = unsyncedTransactions
          .where((transaction) =>
              !deletedTransactions.any((d) => d.id == transaction.id))
          .toList();


      for (final transaction in remainingUnsynced) {
        try {

          if (transaction.isUpdated) {
            // Update existing transaction on remote server
            await _remoteDataSource.updateTransaction(transaction);

            // Update local transaction with sync status
            final updatedTransaction = transaction.copyWith(
              isSynced: true,
              isUpdated: false,
            );
            await _localDataSource
                .update(_mapper.toHiveModel(updatedTransaction));
          } else {
            // Add new transaction to remote server
            final remoteTransaction =
                await _remoteDataSource.addTransaction(transaction);

            // Update local transaction with remote ID and sync status
            final updatedTransaction = transaction.copyWith(
              id: remoteTransaction.id,
              isSynced: true,
              isUpdated: false,
            );

            // Delete the old local record
            final hiveModel = _mapper.toHiveModel(transaction);
            await _localDataSource.delete(hiveModel);

            // Save the updated transaction with remote ID
            await _localDataSource
                .save(_mapper.toHiveModel(updatedTransaction));
          }
        } catch (e) {
          // Continue with next transaction even if one fails
          continue;
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
