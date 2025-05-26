import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart'
    as get_transactions;
import 'package:expense_tracker/features/transaction/domain/usecases/add_transaction.dart'
    as add_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/update_transaction.dart'
    as update_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/delete_transaction.dart'
    as delete_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/sync_transactions.dart'
    as sync_transactions;
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:expense_tracker/core/services/notification/notification_service.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_category.dart'
    as get_category;

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final get_transactions.GetTransactions getTransactions;
  final add_transaction.AddTransaction addTransaction;
  final update_transaction.UpdateTransaction updateTransaction;
  final delete_transaction.DeleteTransaction deleteTransaction;
  final sync_transactions.SyncTransactions syncTransactions;
  final String userId;
  final NotificationService _notificationService;
  final get_category.GetCategory getCategory;

  TransactionBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.syncTransactions,
    required this.userId,
    required this.getCategory,
    required NotificationService notificationService,
  })  : _notificationService = notificationService,
        super(TransactionInitial()) {
    on<GetTransactions>(_onGetTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<SyncTransactions>(_onSyncTransactions);
  }

  Future<void> _onGetTransactions(
    GetTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final result = await getTransactions(UserParams(userId: userId));
      await result.fold(
        (failure) async => emit(TransactionError(failure.toString())),
        (transactions) async {
          // Schedule notifications for upcoming transactions
          for (final transaction in transactions) {
            if (transaction.date.isAfter(DateTime.now())) {
              await _notificationService
                  .scheduleTransactionNotification(transaction);
            }
          }
          emit(TransactionLoaded(transactions));
        },
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final result = await addTransaction(event.transaction);
      await result.fold(
        (failure) async => emit(TransactionError(failure.toString())),
        (_) async {
          // Get the current state
          final currentState = state;
          if (currentState is TransactionLoaded) {
            // Keep showing the current transactions while fetching new ones
            final transactionsResult =
                await getTransactions(UserParams(userId: userId));
            await transactionsResult.fold(
              (failure) async => emit(TransactionError(failure.toString())),
              (transactions) async => emit(TransactionLoaded(transactions)),
            );
          } else {
            // If we're not in a loaded state, fetch all transactions
            final transactionsResult =
                await getTransactions(UserParams(userId: userId));
            await transactionsResult.fold(
              (failure) async => emit(TransactionError(failure.toString())),
              (transactions) async => emit(TransactionLoaded(transactions)),
            );
          }

          // After adding a transaction
          final categoryResult = await getCategory(get_category.Params(
              id: event.transaction.categoryId, userId: userId));
          categoryResult.fold(
            (failure) => null,
            (category) async {
              if (category != null) {
                await _checkBudgetAlerts(category);
              }
            },
          );
        },
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final result = await updateTransaction(event.transaction);
      await result.fold(
        (failure) async => emit(TransactionError(failure.toString())),
        (_) async {
          final transactionsResult =
              await getTransactions(UserParams(userId: userId));
          await transactionsResult.fold(
            (failure) async => emit(TransactionError(failure.toString())),
            (transactions) async => emit(TransactionLoaded(transactions)),
          );
        },
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final result = await deleteTransaction(event.transaction);
      await result.fold(
        (failure) async => emit(TransactionError(failure.toString())),
        (_) async {
          final transactionsResult =
              await getTransactions(UserParams(userId: userId));
          await transactionsResult.fold(
            (failure) async => emit(TransactionError(failure.toString())),
            (transactions) async => emit(TransactionLoaded(transactions)),
          );
        },
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onSyncTransactions(
    SyncTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await syncTransactions(NoParams());
    result.fold(
      (failure) => emit(TransactionError(failure.toString())),
      (_) async {
        // After sync, get the updated transactions
        final transactionsResult =
            await getTransactions(UserParams(userId: userId));
        transactionsResult.fold(
          (failure) => emit(TransactionError(failure.toString())),
          (transactions) async {
            // Schedule notifications for upcoming transactions
            for (final transaction in transactions) {
              if (transaction.date.isAfter(DateTime.now())) {
                await _notificationService
                    .scheduleTransactionNotification(transaction);
              }
            }
            emit(TransactionLoaded(transactions));
          },
        );
      },
    );
  }

  Future<void> _checkBudgetAlerts(Category category) async {
    await _notificationService.scheduleBudgetNotification(category);
  }
}
