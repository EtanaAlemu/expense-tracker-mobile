import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:expense_tracker/features/category/data/local/category_local_data_source.dart';
import 'package:expense_tracker/features/category/data/mappers/category_mapper.dart';
import 'package:expense_tracker/features/category/data/remote/category_remote_data_source.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryMapper mapper;
  final NetworkInfo networkInfo;
  final AppLocalizations _l10n;

  CategoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.mapper,
    required this.networkInfo,
    required AppLocalizations l10n,
  }) : _l10n = l10n;

  @override
  Future<Either<Failure, List<Category>>> getCategories(NoParams params) async {
    try {
      // First get local data and return immediately
      final localResult = await getLocalCategories();
      List<Category> categories = [];

      localResult.fold(
        (failure) => null, // Ignore local failure
        (localCategories) => categories = localCategories,
      );

      // Start remote fetch in background
      if (await networkInfo.isConnected) {
        getRemoteCategories().then((remoteResult) {
          remoteResult.fold(
            (failure) => null, // If remote fails, keep local data
            (remoteCategories) async {
              // Create a map of existing categories by name and ID for quick lookup
              final existingCategoriesByName = {
                for (var category in categories) category.name: category
              };
              final existingCategoriesById = {
                for (var category in categories) category.id: category
              };

              // Only add new categories that don't exist locally
              for (var remote in remoteCategories) {
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

  @override
  Future<Either<Failure, List<Category>>> getLocalCategories() async {
    try {
      final hiveModels = await localDataSource.getAll();
      return Right(hiveModels.map(mapper.toEntity).toList());
    } catch (e) {
      return Left(CacheFailure(_l10n.get('failed_to_cache_categories')));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getRemoteCategories() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(_l10n.get('no_internet_connection')));
    }

    try {
      final remoteCategories = await remoteDataSource.getCategories();
      return Right(remoteCategories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategory(String id) async {
    try {
      // First try local
      final hiveModel = await localDataSource.get(id);
      if (hiveModel != null) {
        return Right(mapper.toEntity(hiveModel));
      }

      // Then try remote if we have internet
      if (await networkInfo.isConnected) {
        final remoteCategory = await remoteDataSource.getCategory(id);
        if (remoteCategory == null) {
          return Left(CacheFailure(_l10n.get('category_not_found_cache')));
        }
        await cacheCategory(remoteCategory);
        return Right(remoteCategory);
      }

      return Left(CacheFailure(_l10n.get('category_not_found_cache')));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> addCategory(Category category) async {
    try {
      print('➕ Adding category: ${category.name}');

      // Create a local ID using timestamp if not provided
      final localId = category.id;
      print('📝 Generated local ID: $localId');

      // Create category with local ID and not synced flag
      final localCategory = category.copyWith(
        id: localId,
        isSynced: false,
      );

      // Save locally first
      print('💾 Saving category locally...');
      final hiveModel = mapper.toHiveModel(localCategory);
      await localDataSource.save(hiveModel);
      print('✅ Category saved locally');

      // Then try to add remotely if we have internet
      if (await networkInfo.isConnected) {
        print('🌐 Internet available, syncing with server...');
        try {
          final remoteCategory =
              await remoteDataSource.addCategory(localCategory);
          print(
              '✅ Category synced with server, remote ID: ${remoteCategory.id}');

          // Update local category with remote ID and sync flag
          final updatedCategory = localCategory.copyWith(
            id: remoteCategory.id, // Update with remote ID
            isSynced: true,
          );
          print('🔄 Updating local category with remote ID and sync status');

          // Delete the old local record
          await localDataSource.delete(hiveModel);
          print('🗑️ Deleted old local record with ID: $localId');

          // Save the updated category with remote ID
          await localDataSource.save(mapper.toHiveModel(updatedCategory));
          print(
              '✅ Saved updated category with remote ID: ${remoteCategory.id}');

          return Right(updatedCategory);
        } catch (e) {
          print('❌ Failed to sync with server: $e');
          // Return local category if remote sync fails
          return Right(localCategory);
        }
      } else {
        print('📡 No internet connection, category saved locally only');
        return Right(localCategory);
      }
    } catch (e) {
      print('❌ Error adding category: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    try {
      // First update locally
      await localDataSource.update(mapper.toHiveModel(category));

      // Then try to update remotely if we have internet
      if (await networkInfo.isConnected) {
        await remoteDataSource.updateCategory(category);
      }

      return Right(category);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(Category category) async {
    try {
      print('🗑️ Deleting category: ${category.name} (${category.id})');

      // First delete locally
      if (category.id.isNotEmpty) {
        print('💾 Deleting from local storage with ID: ${category.id}');
        final hiveModel = mapper.toHiveModel(category);
        await localDataSource.delete(hiveModel);
        print('✅ Category deleted from local storage');
      } else {
        print('⚠️ Cannot delete from local storage: No ID provided');
        return Left(ServerFailure(_l10n.get('category_id_required')));
      }

      // Then try to delete remotely if we have internet
      if (await networkInfo.isConnected) {
        final id = category.id;
        if (id.isEmpty) {
          print('❌ Cannot delete from server: No ID provided');
          return Left(ServerFailure(_l10n.get('category_id_required')));
        }
        print('🌐 Deleting from server with ID: $id');
        try {
          await remoteDataSource.deleteCategory(id);
          print('✅ Category deleted from server');
        } catch (e) {
          print('⚠️ Failed to delete from server: $e');
          // Don't return error, consider local deletion successful
        }
      } else {
        print('📡 No internet connection, category deleted locally only');
      }

      return const Right(null);
    } catch (e) {
      print('❌ Error deleting category: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesByType(
      String type) async {
    try {
      print('🔄 Getting categories by type: $type');

      // First get local data
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

          categories = localCategories.where((category) {
            final matches = category.type == type;
            print(
                '   Checking ${category.name}: type=${category.type}, matches=$matches');
            return matches;
          }).toList();

          print('✅ Found ${categories.length} local categories of type $type');
          categories.forEach((cat) => print('   - ${cat.name} (${cat.id})'));
        },
      );

      // Then try to get remote data if we have internet
      if (await networkInfo.isConnected) {
        print('🌐 Internet available, fetching remote categories...');
        try {
          final remoteCategories =
              await remoteDataSource.getCategoriesByType(type);
          print('📥 Received ${remoteCategories.length} remote categories');
          remoteCategories.forEach((cat) =>
              print('   - ${cat.name} (${cat.id}) [Type: ${cat.type}]'));

          // Create a map of existing categories by name and ID for quick lookup
          final existingCategoriesByName = {
            for (var category in categories) category.name: category
          };
          final existingCategoriesById = {
            for (var category in categories) category.id: category
          };

          print('🔄 Merging remote categories with local data...');
          // Only add new categories that don't exist locally
          for (var remote in remoteCategories) {
            final existingByName = existingCategoriesByName[remote.name];
            final existingById = existingCategoriesById[remote.id];

            if (existingByName == null && existingById == null) {
              print('➕ Adding new category: ${remote.name} (${remote.id})');
              categories.add(remote);
              await cacheCategory(remote);
            } else if (existingById != null && existingByName == null) {
              print(
                  '🔄 Updating category name: ${existingById.name} -> ${remote.name}');
              final updatedCategory = existingById.copyWith(name: remote.name);
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
        } catch (e) {
          print('❌ Error fetching remote categories: $e');
          // Don't return error, just continue with local data
        }
      } else {
        print('📡 No internet connection, using local data only');
      }

      // Remove any duplicates
      print('🧹 Removing duplicates...');
      categories = categories.fold<List<Category>>([], (unique, category) {
        final exists =
            unique.any((c) => c.name == category.name || c.id == category.id);
        if (!exists) {
          unique.add(category);
        } else {
          print('🗑️ Removed duplicate: ${category.name} (${category.id})');
        }
        return unique;
      });

      print('✅ Final category count: ${categories.length}');
      categories.forEach((cat) => print('   - ${cat.name} (${cat.id})'));

      return Right(categories);
    } catch (e) {
      print('❌ Error in getCategoriesByType: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheCategory(Category category) async {
    try {
      final hiveModel = mapper.toHiveModel(category);
      await localDataSource.save(hiveModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(_l10n.get('failed_to_cache_category')));
    }
  }

  @override
  Future<Either<Failure, void>> cacheCategories(
      List<Category> categories) async {
    try {
      final hiveModels = categories.map(mapper.toHiveModel).toList();
      await localDataSource.saveAll(hiveModels);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(_l10n.get('failed_to_cache_categories')));
    }
  }

  @override
  Future<Either<Failure, Category?>> getRemoteCategory(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(_l10n.get('no_internet_connection')));
    }

    try {
      final category = await remoteDataSource.getCategory(id);
      return Right(category);
    } catch (e) {
      return Left(ServerFailure(_l10n.get('failed_to_get_remote_category')));
    }
  }

  @override
  Future<Either<Failure, void>> addRemoteCategory(Category category) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(_l10n.get('no_internet_connection')));
    }

    try {
      await remoteDataSource.addCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(_l10n.get('failed_to_add_remote_category')));
    }
  }

  @override
  Future<Either<Failure, void>> updateRemoteCategory(Category category) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(_l10n.get('no_internet_connection')));
    }

    try {
      await remoteDataSource.updateCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(_l10n.get('failed_to_update_remote_category')));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRemoteCategory(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(_l10n.get('no_internet_connection')));
    }

    try {
      await remoteDataSource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(_l10n.get('failed_to_delete_remote_category')));
    }
  }
}
