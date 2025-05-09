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
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      print('🔄 Getting transactions - Starting...');

      // First get and return local data immediately
      print('📱 Getting local transactions...');
      final localResult = await getLocalTransactions();
      List<Transaction> transactions = [];

      localResult.fold(
        (failure) {
          print('❌ Local data fetch failed: ${failure.message}');
          return null;
        },
        (localTransactions) {
          print('✅ Got ${localTransactions.length} local transactions');
          transactions = List.from(localTransactions)
            ..sort((a, b) => b.date.compareTo(a.date));
          return null;
        },
      );

      // Start loading remote data in the background
      if (await _networkInfo.isConnected) {
        print('🌐 Connected to internet, fetching remote data...');
        getRemoteTransactions().then((remoteResult) async {
          await remoteResult.fold(
            (failure) async {
              print('❌ Remote data fetch failed: ${failure.message}');
              return null;
            },
            (remoteTransactions) async {
              print('✅ Got ${remoteTransactions.length} remote transactions');

              // Create a map of existing transactions by ID for quick lookup
              final existingTransactionsById = {
                for (var transaction in transactions)
                  transaction.id: transaction
              };

              // Only add new transactions that don't exist locally
              int newTransactions = 0;
              for (var remote in remoteTransactions) {
                if (!existingTransactionsById.containsKey(remote.id)) {
                  transactions.add(remote);
                  await cacheTransaction(remote);
                  newTransactions++;
                  print(
                      '📥 Added new transaction: ${remote.id} - ${remote.description}');
                }
              }
              print('📥 Added $newTransactions new transactions from remote');

              // Re-sort the list after adding new transactions
              transactions.sort((a, b) => b.date.compareTo(a.date));
            },
          );
        });
      } else {
        print('📡 No internet connection, using local data only');
      }

      print('📤 Returning ${transactions.length} transactions');
      return Right(transactions);
    } catch (e) {
      print('❌ Error in getTransactions: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Transaction>>> getLocalTransactions() async {
    try {
      print('📱 Getting local transactions from storage...');
      final hiveModels = await _localDataSource.getAll();
      final transactions =
          hiveModels.map((model) => _mapper.toEntity(model)).toList();
      print(
          '✅ Retrieved ${transactions.length} transactions from local storage');
      return Right(transactions);
    } catch (e) {
      print('❌ Error getting local transactions: $e');
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
  Future<Either<Failure, void>> addTransaction(Transaction transaction) async {
    try {
      print('➕ Adding transaction: ${transaction.description}');

      // Create a local ID using timestamp if not provided
      final localId = transaction.id.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : transaction.id;
      print('📝 Generated local ID: $localId');

      // Create transaction with local ID and not synced flag
      final localTransaction = transaction.copyWith(
        id: localId,
        isSynced: false,
      );

      // Save locally first
      print('💾 Saving transaction locally...');
      final hiveModel = _mapper.toHiveModel(localTransaction);
      await _localDataSource.save(hiveModel);
      print('✅ Transaction saved locally');

      // Then try to add remotely if we have internet
      if (await _networkInfo.isConnected) {
        print('🌐 Internet available, syncing with server...');
        try {
          final remoteTransaction =
              await _remoteDataSource.addTransaction(localTransaction);
          print(
              '✅ Transaction synced with server, remote ID: ${remoteTransaction.id}');

          // Update local transaction with remote ID and sync flag
          final updatedTransaction = localTransaction.copyWith(
            id: remoteTransaction.id, // Update with remote ID
            isSynced: true,
          );
          print('🔄 Updating local transaction with remote ID and sync status');

          // Delete the old local record
          await _localDataSource.delete(hiveModel);
          print('🗑️ Deleted old local record with ID: $localId');

          // Save the updated transaction with remote ID
          await _localDataSource.save(_mapper.toHiveModel(updatedTransaction));
          print(
              '✅ Saved updated transaction with remote ID: ${remoteTransaction.id}');

          return const Right(null);
        } catch (e) {
          print('❌ Failed to sync with server: $e');
          // Return local transaction if remote sync fails
          return const Right(null);
        }
      } else {
        print('📡 No internet connection, transaction saved locally only');
        return const Right(null);
      }
    } catch (e) {
      print('❌ Error adding transaction: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
      Transaction transaction) async {
    try {
      // First update locally
      final hiveModel = _mapper.toHiveModel(transaction);
      await _localDataSource.update(hiveModel);

      // Then try to update remotely if we have internet
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.updateTransaction(transaction);
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(
      Transaction transaction) async {
    try {
      // First delete locally
      final id = transaction.id;
      if (id.isEmpty) {
        print('❌ Transaction ID is required');
        return Left(ServerFailure('Transaction ID is required'));
      }
      await _localDataSource.delete(id);

      // Then try to delete remotely if we have internet
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.deleteTransaction(id);
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
      String type) async {
    try {
      // First try local
      final hiveModels = await _localDataSource.getAll();
      final localTransactions = hiveModels
          .map(_mapper.toEntity)
          .where((transaction) => transaction.type == type)
          .toList();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions);
      }

      // Then try remote if we have internet
      if (await _networkInfo.isConnected) {
        final remoteTransactions =
            await _remoteDataSource.getTransactionsByType(type);
        if (remoteTransactions.isNotEmpty) {
          await cacheTransactions(remoteTransactions);
        }
        return Right(remoteTransactions);
      }

      return Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
      String categoryId) async {
    try {
      // First try local
      final hiveModels = await _localDataSource.getAll();
      final localTransactions = hiveModels
          .map(_mapper.toEntity)
          .where((transaction) => transaction.categoryId == categoryId)
          .toList();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions);
      }

      // Then try remote if we have internet
      if (await _networkInfo.isConnected) {
        final remoteTransactions =
            await _remoteDataSource.getTransactionsByCategory(categoryId);
        if (remoteTransactions.isNotEmpty) {
          await cacheTransactions(remoteTransactions);
        }
        return Right(remoteTransactions);
      }

      return Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // First try local
      final hiveModels = await _localDataSource.getAll();
      final localTransactions = hiveModels
          .map(_mapper.toEntity)
          .where((transaction) =>
              transaction.date.isAfter(startDate) &&
              transaction.date.isBefore(endDate))
          .toList();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions);
      }

      // Then try remote if we have internet
      if (await _networkInfo.isConnected) {
        final remoteTransactions = await _remoteDataSource
            .getTransactionsByDateRange(startDate, endDate);
        if (remoteTransactions.isNotEmpty) {
          await cacheTransactions(remoteTransactions);
        }
        return Right(remoteTransactions);
      }

      return Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalTransactionsByType(
      String type) async {
    try {
      final result = await getTransactionsByType(type);
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
      String categoryId) async {
    try {
      final result = await getTransactionsByCategory(categoryId);
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
  ) async {
    try {
      final result = await getTransactionsByDateRange(startDate, endDate);
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
}
