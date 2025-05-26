import 'dart:async';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_event.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_state.dart';
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
import 'package:expense_tracker/features/category/domain/usecases/sync_categories.dart'
    as sync_categories;
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions_by_category.dart'
    as get_transactions_by_category;
import 'package:expense_tracker/core/services/notification/notification_service.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final get_categories.GetCategories getCategories;
  final get_category.GetCategory getCategory;
  final add_category.AddCategory addCategory;
  final update_category.UpdateCategory updateCategory;
  final delete_category.DeleteCategory deleteCategory;
  final get_categories_by_type.GetCategoriesByType getCategoriesByType;
  final sync_categories.SyncCategories syncCategories;
  final get_transactions_by_category.GetTransactionsByCategory
      getTransactionsByCategory;
  final String userId;
  final NotificationService _notificationService;

  CategoryBloc({
    required this.getCategories,
    required this.getCategory,
    required this.getTransactionsByCategory,
    required this.getCategoriesByType,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
    required this.syncCategories,
    required this.userId,
    required NotificationService notificationService,
  })  : _notificationService = notificationService,
        super(CategoryInitial()) {
    on<GetCategories>(_onGetCategories);
    on<GetCategory>(_onGetCategory);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<GetCategoriesByType>(_onGetCategoriesByType);
    on<SyncCategories>(_onSyncCategories);
    on<ClearCategories>(_onClearCategories);
  }

  Future<void> _onGetCategories(
    GetCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(const CategoryLoading());
      final result = await getCategories(UserParams(userId: userId));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (categories) async => emit(CategoryLoaded(categories)),
      );
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onGetCategory(
    GetCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(CategoryLoading());
      final result =
          await getCategory(get_category.Params(id: event.id, userId: userId));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (category) async {
          if (category != null) {
            emit(CategoryLoaded([category]));
          } else {
            emit(CategoryError("Category not found"));
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
    try {
      emit(const CategoryLoading());
      final result = await addCategory(
          add_category.Params(category: event.category, userId: userId));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (category) async {
          await _checkBudgetAlerts(category);
          final categoriesResult =
              await getCategories(UserParams(userId: userId));
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

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      if (event.category.id.isEmpty) {
        emit(CategoryError("Category id required"));
        return;
      }

      emit(const CategoryLoading());
      final result = await updateCategory(
          update_category.Params(category: event.category));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (category) async {
          // Get updated categories list
          final categoriesResult =
              await getCategories(UserParams(userId: userId));
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

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      // Get current categories before checking transactions
      final currentState = state;
      final currentCategories =
          currentState is CategoryLoaded ? currentState.categories : null;
      print('📋 Current categories count: ${currentCategories?.length ?? 0}');

      // Check if category has transactions
      print('🔍 Checking for transactions in category: ${event.category.id}');
      final transactionsResult = await getTransactionsByCategory(
        get_transactions_by_category.CategoryParams(
          categoryId: event.category.id,
          userId: userId,
        ),
      );

      await transactionsResult.fold(
        (failure) async {
          print('❌ Error checking transactions: ${failure.message}');
          emit(CategoryError(_mapFailureToMessage(failure),
              previousCategories: currentCategories));
        },
        (transactions) async {
          print('📊 Found ${transactions.length} transactions in category');
          if (transactions.isNotEmpty) {
            print('⚠️ Category has transactions, cannot delete');
            emit(CategoryError("Category has transactions, cannot delete",
                previousCategories: currentCategories));
            return;
          }

          print('✅ No transactions found, proceeding with deletion');
          emit(const CategoryLoading());
          final result = await deleteCategory(
              delete_category.Params(category: event.category, userId: userId));
          await result.fold(
            (failure) async {
              print('❌ Error deleting category: ${failure.message}');
              emit(CategoryError(_mapFailureToMessage(failure),
                  previousCategories: currentCategories));
            },
            (_) async {
              print('✅ Category deleted successfully, refreshing list');
              // Get updated categories list
              final categoriesResult =
                  await getCategories(UserParams(userId: userId));
              await categoriesResult.fold(
                (failure) async {
                  print('❌ Error refreshing categories: ${failure.message}');
                  emit(CategoryError(_mapFailureToMessage(failure),
                      previousCategories: currentCategories));
                },
                (categories) async {
                  print('✅ Categories refreshed successfully');
                  emit(CategoryLoaded(categories));
                },
              );
            },
          );
        },
      );
    } catch (e) {
      print('❌ Unexpected error during category deletion: $e');
      final currentState = state;
      final currentCategories =
          currentState is CategoryLoaded ? currentState.categories : null;
      emit(CategoryError(e.toString(), previousCategories: currentCategories));
    }
  }

  Future<void> _onGetCategoriesByType(
    GetCategoriesByType event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(CategoryLoading());
      final result = await getCategoriesByType(
          get_categories_by_type.Params(type: event.type, userId: userId));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (categories) async => emit(CategoryLoaded(categories)),
      );
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onSyncCategories(
    SyncCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      // Keep current categories in case of error
      final currentState = state;
      final currentCategories =
          currentState is CategoryLoaded ? currentState.categories : null;

      emit(const CategoryLoading());
      final result = await syncCategories(NoParams());
      await result.fold(
        (failure) async {
          print('❌ Sync failed: ${failure.message}');
          emit(CategoryError(_mapFailureToMessage(failure),
              previousCategories: currentCategories));
        },
        (_) async {
          print('✅ Sync completed, refreshing categories');
          // Get updated categories list
          final categoriesResult =
              await getCategories(UserParams(userId: userId));
          await categoriesResult.fold(
            (failure) async {
              print('❌ Failed to get updated categories: ${failure.message}');
              emit(CategoryError(_mapFailureToMessage(failure),
                  previousCategories: currentCategories));
            },
            (categories) async {
              print('✅ Got ${categories.length} updated categories');
              // Filter out any deleted categories
              final activeCategories =
                  categories.where((cat) => !cat.isDeleted).toList();
              print('✅ Found ${activeCategories.length} active categories');

              // Update the state with the new categories
              if (activeCategories.isEmpty) {
                print('ℹ️ No active categories found after sync');
                emit(const CategoryLoaded([]));
              } else {
                print(
                    '📋 Emitting updated category list with ${activeCategories.length} categories');
                activeCategories
                    .forEach((cat) => print('   - ${cat.name} (${cat.id})'));
                emit(CategoryLoaded(activeCategories));
              }
            },
          );
        },
      );
    } catch (e) {
      print('❌ Error during sync: $e');
      final currentState = state;
      final currentCategories =
          currentState is CategoryLoaded ? currentState.categories : null;
      emit(CategoryError(e.toString(), previousCategories: currentCategories));
    }
  }

  void _onClearCategories(ClearCategories event, Emitter<CategoryState> emit) {
    emit(CategoryInitial());
  }

  Future<void> _checkBudgetAlerts(Category category) async {
    await _notificationService.scheduleBudgetNotification(category);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "Server failure";
      case CacheFailure:
        return "Cache failure";
      default:
        return "Unexpected error";
    }
  }
}
