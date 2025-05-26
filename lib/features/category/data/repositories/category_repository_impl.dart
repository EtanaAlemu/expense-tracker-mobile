import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:expense_tracker/features/category/data/local/category_local_data_source.dart';
import 'package:expense_tracker/features/category/data/mappers/category_mapper.dart';
import 'package:expense_tracker/features/category/data/remote/category_remote_data_source.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource _localDataSource;
  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryMapper _mapper;
  final NetworkInfo _networkInfo;
  final TransactionRepository _transactionRepository;

  CategoryRepositoryImpl({
    required CategoryLocalDataSource localDataSource,
    required CategoryRemoteDataSource remoteDataSource,
    required CategoryMapper mapper,
    required NetworkInfo networkInfo,
    required TransactionRepository transactionRepository,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _mapper = mapper,
        _networkInfo = networkInfo,
        _transactionRepository = transactionRepository;

  @override
  Future<Either<Failure, List<Category>>> getCategories(String userId) async {
    try {
      // First get local data and return immediately
      final localResult = await getLocalCategories();
      List<Category> categories = [];

      print(
          '🔍 Local categories: ${localResult.fold((failure) => [], (categories) => categories)}');
      print('🔍 User ID: $userId');

      localResult.fold(
        (failure) => null, // Ignore local failure
        (localCategories) {
          // Filter out deleted categories and empty IDs
          categories = localCategories
              .where((category) =>
                  category.userId == userId &&
                  !category.isDeleted &&
                  category.id.isNotEmpty)
              .toList();
        },
      );

      // Start remote fetch in background
      if (await _networkInfo.isConnected) {
        getRemoteCategories().then((remoteResult) {
          remoteResult.fold(
            (failure) => null, // If remote fails, keep local data
            (remoteCategories) async {
              // Filter out deleted categories and empty IDs from remote data
              final filteredRemoteCategories = remoteCategories
                  .where((category) =>
                      !category.isDeleted && category.id.isNotEmpty)
                  .toList();

              // Create a map of existing categories by name and ID for quick lookup
              final existingCategoriesByName = {
                for (var category in categories) category.name: category
              };
              final existingCategoriesById = {
                for (var category in categories) category.id: category
              };

              // Only add new categories that don't exist locally
              for (var remote in filteredRemoteCategories) {
                final existingByName = existingCategoriesByName[remote.name];
                final existingById = existingCategoriesById[remote.id];

                if (existingByName == null && existingById == null) {
                  categories.add(remote);
                  await cacheCategory(remote);
                } else if (existingById != null && existingByName == null) {
                  // Update name if ID matches but name is different
                  final updatedCategory =
                      existingById.copyWith(name: remote.name);
                  await updateCategory(updatedCategory);
                  final index = categories.indexOf(existingById);
                  if (index != -1) {
                    categories[index] = updatedCategory;
                  }
                }
              }

              // Remove any duplicates (same name or ID)
              categories =
                  categories.fold<List<Category>>([], (unique, category) {
                final exists = unique
                    .any((c) => c.name == category.name || c.id == category.id);
                if (!exists) {
                  unique.add(category);
                }
                return unique;
              });
            },
          );
        });
      }

      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Category>>> getLocalCategories() async {
    try {
      final hiveModels = await _localDataSource.getAll();
      return Right(hiveModels.map(_mapper.toEntity).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to cache categories'));
    }
  }

  Future<Either<Failure, List<Category>>> getRemoteCategories() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final remoteCategories = await _remoteDataSource.getCategories();
      return Right(remoteCategories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategory(
      String id, String userId) async {
    try {
      // First try local
      final hiveModel = await _localDataSource.get(id);
      if (hiveModel != null) {
        final category = _mapper.toEntity(hiveModel);
        // Check if category is deleted or has empty ID
        if (category.isDeleted ||
            category.id.isEmpty ||
            category.userId != userId) {
          return Left(CacheFailure('Category not found'));
        }
        return Right(category);
      }

      // Then try remote if we have internet
      if (await _networkInfo.isConnected) {
        final remoteCategory = await _remoteDataSource.getCategory(id);
        if (remoteCategory == null ||
            remoteCategory.isDeleted ||
            remoteCategory.id.isEmpty) {
          return Left(CacheFailure('Category not found'));
        }
        await cacheCategory(remoteCategory);
        return Right(remoteCategory);
      }

      return Left(CacheFailure('Category not found'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> addCategory(Category category) async {
    try {
      debugPrint('➕ Adding category: ${category.name}');
      // Create a local ID using timestamp if not provided
      var localId = category.id;
      if (localId.isEmpty) {
        localId = DateTime.now().millisecondsSinceEpoch.toString();
      }
      debugPrint('📝 Generated local ID: $localId');

      // Create category with local ID and not synced flag
      final localCategory = category.copyWith(
        id: localId,
        isSynced: false,
        isDefault: false,
      );

      // First check internet connectivity
      if (await _networkInfo.isConnected) {
        debugPrint('🌐 Internet available, attempting remote sync first...');
        try {
          // Try to add remotely first
          final remoteCategory =
              await _remoteDataSource.addCategory(localCategory);
          debugPrint(
              '✅ Category synced with server, remote ID: ${remoteCategory.id}');

          // Create updated category with remote ID and sync flag
          final updatedCategory = localCategory.copyWith(
            id: remoteCategory.id,
            isSynced: true, // Ensure this is set to true
            isDefault: false,
          );

          // Save the synced category locally
          debugPrint('💾 Saving synced category locally...');
          final hiveModel = _mapper.toHiveModel(updatedCategory);
          await _localDataSource.save(hiveModel);
          debugPrint('✅ Synced category saved locally with isSynced=true');

          // Verify the saved category
          final savedCategory = await _localDataSource.get(remoteCategory.id);
          if (savedCategory != null) {
            debugPrint(
                '🔍 Verification: Saved category isSynced=${savedCategory.isSynced}');
          }

          return Right(updatedCategory);
        } catch (e) {
          debugPrint('❌ Failed to sync with server: $e');
          debugPrint('🔄 Falling back to local storage only...');
        }
      } else {
        debugPrint(
            '📡 No internet connection, falling back to local storage...');
      }

      // Fallback to local storage only
      debugPrint('💾 Saving category locally only...');
      final hiveModel = _mapper.toHiveModel(localCategory);
      await _localDataSource.save(hiveModel);
      debugPrint('✅ Category saved locally only with isSynced=false');

      // Verify the saved category
      final savedCategory = await _localDataSource.get(localId);
      if (savedCategory != null) {
        debugPrint(
            '🔍 Verification: Saved category isSynced=${savedCategory.isSynced}');
      }

      return Right(localCategory);
    } catch (e) {
      debugPrint('❌ Error adding category: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      print('🔄 Updating category: ${category.name} (${category.id})');
      print(
          '📊 Category sync status: isSynced=${category.isSynced}, isUpdated=${category.isUpdated}');

      // First update locally
      final hiveModel = _mapper.toHiveModel(category);
      await _localDataSource.update(hiveModel);
      print('✅ Updated in local storage');

      if (await _networkInfo.isConnected) {
        print('🌐 Online - attempting to update remote server');
        try {
          // Try to update remote server
          await _remoteDataSource.updateCategory(category);
          print('✅ Successfully updated on remote server');

          // Update local category with sync status and reset isUpdated
          final updatedCategory = category.copyWith(
            isSynced: true,
            isUpdated: false,
          );
          await _localDataSource.update(_mapper.toHiveModel(updatedCategory));
          print('✅ Updated sync status in local storage');
          return Right(updatedCategory);
        } catch (e) {
          print('⚠️ Failed to update on remote server: $e');
          // Mark as unsynced and updated for future sync
          final unsyncedCategory = category.copyWith(
            isSynced: false,
            isUpdated: true,
          );
          await _localDataSource.update(_mapper.toHiveModel(unsyncedCategory));
          print('✅ Marked as unsynced and updated for future sync');
          return Right(unsyncedCategory);
        }
      } else {
        print('📡 Offline - checking category sync status');
        if (!category.isSynced) {
          print('📝 Category was created offline - updating locally only');
          // If category was created offline, update locally only
          final localCategory = category.copyWith(
            isSynced: false,
            isUpdated: false,
          );
          await _localDataSource.update(_mapper.toHiveModel(localCategory));
          print('✅ Updated locally only (will be synced as new when online)');
          return Right(localCategory);
        } else {
          print(
              '📝 Category was synced before - marking as unsynced and updated for future sync');
          // If category was synced before, mark as unsynced and updated for future sync
          final updatedCategory = category.copyWith(
            isSynced: false,
            isUpdated: true,
          );
          await _localDataSource.update(_mapper.toHiveModel(updatedCategory));
          print('✅ Marked as unsynced and updated for future sync');
          return Right(updatedCategory);
        }
      }
    } catch (e) {
      print('❌ Error in updateCategory: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(
      Category category, String userId) async {
    try {
      // Check if category has any non-deleted transactions
      print('🔍 Checking for existing transactions in this category');
      final transactionsResult =
          await _transactionRepository.getTransactions(userId);
      final hasActiveTransactions = transactionsResult.fold(
        (failure) {
          print('❌ Failed to check transactions: $failure');
          return false;
        },
        (transactions) {
          final activeTransactions = transactions
              .where((transaction) =>
                  transaction.categoryId == category.id &&
                  transaction.userId == userId &&
                  !transaction.isDeleted)
              .toList();
          print(
              '📊 Found ${activeTransactions.length} active transactions in this category');
          return activeTransactions.isNotEmpty;
        },
      );

      if (hasActiveTransactions) {
        print('❌ Cannot delete category with active transactions');
        return Left(ValidationFailure(
            'Cannot delete category with active transactions'));
      }

      // First try to delete from remote if online
      if (await _networkInfo.isConnected) {
        print('🌐 Online - attempting to delete from both local and remote');
        try {
          // Get the latest category data to ensure we have the correct ID
          final latestCategoryResult = await getCategory(category.id, userId);
          final latestCategory = latestCategoryResult.fold(
            (failure) {
              print('⚠️ Failed to get latest category data: $failure');
              return category; // Use the original category if we can't get the latest
            },
            (cat) => cat,
          );

          print('📝 Using category ID: ${latestCategory.id} for deletion');

          // Try to delete from remote first
          await _remoteDataSource.deleteCategory(latestCategory.id);
          print('✅ Successfully deleted from remote server');

          // If remote deletion was successful, delete from local storage
          try {
            final hiveModel = _mapper.toHiveModel(latestCategory);
            await _localDataSource.delete(hiveModel);
            print('✅ Successfully deleted from local storage');
          } catch (e) {
            print('⚠️ Failed to delete from local storage: $e');
            // If local deletion fails, mark as deleted for future sync
            final deletedCategory = latestCategory.copyWith(
              isDeleted: true,
            );
            await _localDataSource.update(_mapper.toHiveModel(deletedCategory));
            print('✅ Marked as deleted locally for future sync');
          }
        } catch (e) {
          print('⚠️ Failed to delete from remote server: $e');
          // Mark as deleted locally even if remote deletion fails
          final deletedCategory = category.copyWith(
            isDeleted: true,
          );
          await _localDataSource.update(_mapper.toHiveModel(deletedCategory));
          print('✅ Marked as deleted locally for future sync');
        }
      } else {
        print('📡 Offline - checking category sync status');
        if (!category.isSynced) {
          print(
              '📝 Category was created offline - deleting completely from local storage');
          // If category was created offline, delete it completely
          final hiveModel = _mapper.toHiveModel(category);
          await _localDataSource.delete(hiveModel);
          print(
              '✅ Successfully deleted offline-created category from local storage');
        } else {
          print('📝 Category was synced before - marking for deletion');
          // If category was synced before, mark as deleted for future sync
          final deletedCategory = category.copyWith(
            isDeleted: true,
          );
          await _localDataSource.update(_mapper.toHiveModel(deletedCategory));
          print('✅ Marked as deleted locally for future sync');
        }
      }

      return const Right(null);
    } catch (e) {
      print('❌ Error in deleteCategory: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesByType(
      String type, String userId) async {
    try {
      print('🔄 Getting categories by type: $type');

      // First get local data and return immediately
      print('📱 Fetching local categories...');
      final localResult = await getLocalCategories();
      List<Category> categories = [];

      localResult.fold(
        (failure) {
          print('❌ Local fetch failed: ${failure.message}');
          return null;
        },
        (localCategories) {
          print('📦 Raw local categories:');
          localCategories.forEach((cat) =>
              print('   - ${cat.name} (${cat.id}) [Type: ${cat.type}]'));

          // Filter out deleted categories, match type, and ensure ID is not empty
          categories = localCategories.where((category) {
            final matches = category.type == type &&
                category.userId == userId &&
                !category.isDeleted &&
                category.id.isNotEmpty;
            print(
                '   Checking ${category.name}: type=${category.type}, isDeleted=${category.isDeleted}, id=${category.id}, matches=$matches');
            return matches;
          }).toList();

          print('✅ Found ${categories.length} local categories of type $type');
          categories.forEach((cat) => print('   - ${cat.name} (${cat.id})'));
        },
      );

      // Start remote fetch in background
      if (await _networkInfo.isConnected) {
        print(
            '🌐 Internet available, fetching remote categories in background...');
        getRemoteCategoriesByType(type).then((remoteResult) {
          remoteResult.fold(
            (failure) {
              print('❌ Remote fetch failed: ${failure.message}');
              return null;
            },
            (remoteCategories) async {
              print('📥 Received ${remoteCategories.length} remote categories');

              // Filter out deleted categories and empty IDs from remote data
              final filteredRemoteCategories = remoteCategories
                  .where((category) =>
                      !category.isDeleted && category.id.isNotEmpty)
                  .toList();
              print(
                  '📥 Filtered to ${filteredRemoteCategories.length} non-deleted remote categories');

              // Create a map of existing categories by name and ID for quick lookup
              final existingCategoriesByName = {
                for (var category in categories) category.name: category
              };
              final existingCategoriesById = {
                for (var category in categories) category.id: category
              };

              print('🔄 Merging remote categories with local data...');
              // Only add new categories that don't exist locally
              for (var remote in filteredRemoteCategories) {
                final existingByName = existingCategoriesByName[remote.name];
                final existingById = existingCategoriesById[remote.id];

                if (existingByName == null && existingById == null) {
                  print('➕ Adding new category: ${remote.name} (${remote.id})');
                  categories.add(remote);
                  await cacheCategory(remote);
                } else if (existingById != null && existingByName == null) {
                  print(
                      '🔄 Updating category name: ${existingById.name} -> ${remote.name}');
                  final updatedCategory =
                      existingById.copyWith(name: remote.name);
                  await updateCategory(updatedCategory);
                  final index = categories.indexOf(existingById);
                  if (index != -1) {
                    categories[index] = updatedCategory;
                  }
                } else {
                  print(
                      'ℹ️ Category already exists: ${remote.name} (${remote.id})');
                }
              }

              // Remove any duplicates
              print('🧹 Removing duplicates...');
              categories =
                  categories.fold<List<Category>>([], (unique, category) {
                final exists = unique
                    .any((c) => c.name == category.name || c.id == category.id);
                if (!exists) {
                  unique.add(category);
                } else {
                  print(
                      '🗑️ Removed duplicate: ${category.name} (${category.id})');
                }
                return unique;
              });

              print('✅ Final category count: ${categories.length}');
              categories
                  .forEach((cat) => print('   - ${cat.name} (${cat.id})'));
            },
          );
        });
      } else {
        print('📡 No internet connection, using local data only');
      }

      return Right(categories);
    } catch (e) {
      print('❌ Error in getCategoriesByType: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Category>>> getRemoteCategoriesByType(
      String type) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final remoteCategories =
          await _remoteDataSource.getCategoriesByType(type);
      return Right(remoteCategories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> cacheCategory(Category category) async {
    try {
      final hiveModel = _mapper.toHiveModel(category);
      await _localDataSource.save(hiveModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to cache category'));
    }
  }

  Future<Either<Failure, void>> cacheCategories(
      List<Category> categories) async {
    try {
      final hiveModels = categories.map(_mapper.toHiveModel).toList();
      await _localDataSource.saveAll(hiveModels);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to cache categories'));
    }
  }

  Future<Either<Failure, Category?>> getRemoteCategory(String id) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final category = await _remoteDataSource.getCategory(id);
      return Right(category);
    } catch (e) {
      return Left(ServerFailure('Failed to get remote category'));
    }
  }

  Future<Either<Failure, void>> addRemoteCategory(Category category) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.addCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add remote category'));
    }
  }

  Future<Either<Failure, void>> updateRemoteCategory(Category category) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.updateCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update remote category'));
    }
  }

  Future<Either<Failure, void>> deleteRemoteCategory(String id) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      await _remoteDataSource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete remote category'));
    }
  }

  @override
  Future<Either<Failure, void>> syncCategories() async {
    try {
      // Get all local categories
      final localResult = await getLocalCategories();
      if (localResult.isLeft()) {
        return Left(CacheFailure('Failed to get local categories'));
      }

      final localCategories = localResult.getOrElse(() => []);

      // Filter categories that need syncing
      final unsyncedCategories = localCategories
          .where((category) =>
              (!category.isSynced && !category.isDeleted) ||
              (category.isUpdated && !category.isDeleted))
          .toList();

      // Filter categories marked for deletion
      final deletedCategories = localCategories
          .where((category) => (category.isSynced && category.isDeleted))
          .toList();

      if (unsyncedCategories.isEmpty && deletedCategories.isEmpty) {
        return const Right(null);
      }

      // Check internet connection
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection'));
      }

      // First handle deleted categories
      for (final category in deletedCategories) {
        try {
          // Delete from remote server
          await _remoteDataSource.deleteCategory(category.id);

          // Now remove from local storage
          final hiveModel = _mapper.toHiveModel(category);
          await _localDataSource.delete(hiveModel);
        } catch (e) {
          // Continue with next category even if one fails
          continue;
        }
      }

      // Then handle unsynced/updated categories (excluding any that were just deleted)
      final remainingUnsynced = unsyncedCategories
          .where(
              (category) => !deletedCategories.any((d) => d.id == category.id))
          .toList();

      for (final category in remainingUnsynced) {
        try {
          if (category.isUpdated) {
            // Update existing category on remote server
            await _remoteDataSource.updateCategory(category);

            // Update local category with sync status
            final updatedCategory = category.copyWith(
              isSynced: true,
              isUpdated: false,
            );
            await _localDataSource.update(_mapper.toHiveModel(updatedCategory));
          } else {
            // Add new category to remote server
            final remoteCategory =
                await _remoteDataSource.addCategory(category);

            // Update local category with remote ID and sync status
            final updatedCategory = category.copyWith(
              id: remoteCategory.id,
              isSynced: true,
              isUpdated: false,
            );

            // Delete the old local record
            final hiveModel = _mapper.toHiveModel(category);
            await _localDataSource.delete(hiveModel);

            // Save the updated category with remote ID
            await _localDataSource.save(_mapper.toHiveModel(updatedCategory));
          }
        } catch (e) {
          // Continue with next category even if one fails
          continue;
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
