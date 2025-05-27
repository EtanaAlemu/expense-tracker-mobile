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
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

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
  final AuthRepository _authRepository;
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
    required AuthRepository authRepository,
    required NotificationService notificationService,
  })  : _authRepository = authRepository,
        _notificationService = notificationService,
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

  Future<String> _getUserId() async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(milliseconds: 500);

    while (retryCount < maxRetries) {
      final userResult = await _authRepository.getCurrentUser();
      final userId = userResult.fold(
        (failure) {
          print(
              '❌ Failed to get user ID (attempt ${retryCount + 1}/$maxRetries): ${failure.message}');
          return '';
        },
        (user) {
          print('✅ Successfully retrieved user ID: ${user.id}');
          return user.id;
        },
      );

      if (userId.isNotEmpty) {
        return userId;
      }

      if (retryCount < maxRetries - 1) {
        print('🔄 Retrying in ${retryDelay.inMilliseconds}ms...');
        await Future.delayed(retryDelay);
        retryCount++;
      } else {
        print('❌ Max retries reached, returning empty user ID');
        break;
      }
    }
    return '';
  }

  Future<void> _onGetCategories(
    GetCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(const CategoryLoading());
      final userId = await _getUserId();
      if (userId.isEmpty) {
        print('❌ No user ID available for getting categories');
        emit(const CategoryLoaded([]));
        return;
      }
      final result = await getCategories(UserParams(userId: userId));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (categories) async => emit(CategoryLoaded(categories)),
      );
    } catch (e) {
      print('❌ Error getting categories: $e');
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onGetCategory(
    GetCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(CategoryLoading());
      final userId = await _getUserId();
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
      final userId = await _getUserId();
      final result = await addCategory(
          add_category.Params(category: event.category, userId: userId));
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (category) async {
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
      final userId = await _getUserId();
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

      final userId = await _getUserId();
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
            (success) async {
              print('✅ Category deleted successfully');
              // Get updated categories list
              final categoriesResult =
                  await getCategories(UserParams(userId: userId));
              await categoriesResult.fold(
                (failure) async => emit(CategoryError(
                    _mapFailureToMessage(failure),
                    previousCategories: currentCategories)),
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

  Future<void> _onGetCategoriesByType(
    GetCategoriesByType event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(const CategoryLoading());
      final userId = await _getUserId();
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
      emit(const CategoryLoading());
      final result = await syncCategories(NoParams());
      await result.fold(
        (failure) async => emit(CategoryError(_mapFailureToMessage(failure))),
        (success) async {
          final userId = await _getUserId();
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

  Future<void> _onClearCategories(
    ClearCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      case NetworkFailure:
        return 'Network error occurred';
      default:
        return 'Unexpected error occurred';
    }
  }
}
