import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_categories.dart'
    as get_categories;
import 'package:expense_tracker/features/category/domain/usecases/get_category.dart'
    as get_category;
import 'package:expense_tracker/features/category/domain/usecases/add_category.dart'
    as add_category;
import 'package:expense_tracker/features/category/domain/usecases/update_category.dart'
    as update_category;
import 'package:expense_tracker/features/category/domain/usecases/delete_category.dart'
    as delete_category;
import 'package:expense_tracker/features/category/domain/usecases/get_categories_by_type.dart'
    as get_categories_by_type;
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final get_categories.GetCategories getCategories;
  final get_category.GetCategory getCategory;
  final add_category.AddCategory addCategory;
  final update_category.UpdateCategory updateCategory;
  final delete_category.DeleteCategory deleteCategory;
  final get_categories_by_type.GetCategoriesByType getCategoriesByType;
  final CategoryRepository repository;

  CategoryBloc({
    required this.getCategories,
    required this.getCategory,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
    required this.getCategoriesByType,
    required this.repository,
  }) : super(CategoryInitial()) {
    on<GetCategories>(_onGetCategories);
    on<GetCategory>(_onGetCategory);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<GetCategoriesByType>(_onGetCategoriesByType);
  }

  Future<void> _onGetCategories(
    GetCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      print('🔄 Getting categories...');
      final result = await getCategories(NoParams());
      await result.fold(
        (failure) async {
          print('❌ Error getting categories: ${failure.message}');
          emit(CategoryError(_mapFailureToMessage(failure)));
        },
        (categories) async {
          print('📦 Got ${categories.length} categories from local storage');
          emit(CategoryLoaded(categories));

          // If we have internet, fetch remote data and update
          print('🌐 Fetching remote categories...');
          final remoteResult = await repository.getRemoteCategories();
          await remoteResult.fold(
            (failure) async {
              print('❌ Error getting remote categories: ${failure.message}');
              return null;
            },
            (remoteCategories) async {
              print('📦 Got ${remoteCategories.length} categories from remote');
              // Create a map of existing categories by name and ID for quick lookup
              final existingCategoriesByName = {
                for (var category in categories) category.name: category
              };
              final existingCategoriesById = {
                for (var category in categories)
                  if (category.id != null) category.id!: category
              };

              // Only add new categories that don't exist locally
              for (var remote in remoteCategories) {
                final existingByName = existingCategoriesByName[remote.name];
                final existingById = remote.id != null
                    ? existingCategoriesById[remote.id!]
                    : null;

                if (existingByName == null && existingById == null) {
                  print('➕ Adding new category: ${remote.name}');
                  categories.add(remote);
                  await repository.cacheCategory(remote);
                } else if (existingById != null && existingByName == null) {
                  print(
                      '🔄 Updating category name: ${existingById.name} -> ${remote.name}');
                  final updatedCategory =
                      existingById.copyWith(name: remote.name);
                  await repository.updateCategory(updatedCategory);
                  final index = categories.indexOf(existingById);
                  if (index != -1) {
                    categories[index] = updatedCategory;
                  }
                }
              }

              // Remove any duplicates
              final updatedCategories =
                  categories.fold<List<Category>>([], (unique, category) {
                final exists = unique.any((c) =>
                    c.name == category.name ||
                    (c.id != null && c.id == category.id));
                if (!exists) {
                  unique.add(category);
                }
                return unique;
              });

              print('📦 Final category count: ${updatedCategories.length}');
              // Emit updated state
              if (!emit.isDone) {
                emit(CategoryLoaded(updatedCategories));
              }
            },
          );
        },
      );
    } catch (e) {
      print('❌ Error in _onGetCategories: $e');
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onGetCategory(
    GetCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final result = await getCategory(get_category.Params(id: event.id));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (category) async {
          if (category != null) {
            emit(CategoryLoaded([category]));
          } else {
            emit(CategoryError('Category not found'));
          }
        },
      );
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      print('📝 Adding category: ${event.category.name}');
      final result =
          await addCategory(add_category.Params(category: event.category));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (_) async {
          print('✅ Category added successfully');

          // Get the latest categories list
          final categoriesResult = await getCategories(NoParams());
          await categoriesResult.fold(
            (failure) async =>
                emit(CategoryError(_mapFailureToMessage(failure))),
            (categories) async {
              // Create a map of categories by name and type for quick lookup
              final categoryMap = <String, Category>{};
              for (var category in categories) {
                final key = '${category.name}_${category.type}';
                // If we find a category with the same name and type, prefer the one with remote ID
                if (!categoryMap.containsKey(key) ||
                    (category.id != null && category.id!.startsWith('681'))) {
                  categoryMap[key] = category;
                }
              }

              // Convert map back to list
              final updatedCategories = categoryMap.values.toList();

              print('📦 Updated category list:');
              updatedCategories
                  .forEach((cat) => print('   - ${cat.name} (${cat.id})'));

              emit(CategoryLoaded(updatedCategories));
            },
          );
        },
      );
    } catch (e) {
      print('❌ Error adding category: $e');
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      if (event.category.id == null || event.category.id!.isEmpty) {
        emit(CategoryError('Category ID is required'));
        return;
      }

      final categoryResult =
          await getCategory(get_category.Params(id: event.category.id!));
      await categoryResult.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (category) async {
          if (category == null) {
            emit(CategoryError('Category not found'));
            return;
          }

          if (category.isDefault) {
            emit(CategoryError('Cannot update default categories'));
            return;
          }

          emit(CategoryLoading());
          final result = await updateCategory(
              update_category.Params(category: event.category));
          await result.fold(
            (failure) async =>
                emit(CategoryError(_mapFailureToMessage(failure))),
            (_) async {
              final categoriesResult = await getCategories(NoParams());
              await categoriesResult.fold(
                (failure) async =>
                    emit(CategoryError(_mapFailureToMessage(failure))),
                (categories) async => emit(CategoryLoaded(categories)),
              );
            },
          );
        },
      );
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      if (event.category.id == null || event.category.id!.isEmpty) {
        emit(CategoryError('Category ID is required'));
        return;
      }

      // Check if it's a default category
      if (event.category.isDefault) {
        emit(CategoryError('Cannot delete default categories'));
        return;
      }

      emit(CategoryLoading());
      final result = await deleteCategory(
          delete_category.Params(category: event.category));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (_) async {
          // Get updated categories list
          final categoriesResult = await getCategories(NoParams());
          await categoriesResult.fold(
            (failure) async =>
                emit(CategoryError(_mapFailureToMessage(failure))),
            (categories) async => emit(CategoryLoaded(categories)),
          );
        },
      );
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onGetCategoriesByType(
    GetCategoriesByType event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final result = await getCategoriesByType(
          get_categories_by_type.Params(type: event.type));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (categories) async => emit(CategoryLoaded(categories)),
      );
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server failure';
      case CacheFailure:
        return 'Cache failure';
      default:
        return 'Unexpected error';
    }
  }
}
