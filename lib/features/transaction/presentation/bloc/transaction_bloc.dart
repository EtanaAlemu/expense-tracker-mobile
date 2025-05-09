import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart'
    as get_transactions;
import 'package:expense_tracker/features/transaction/domain/usecases/add_transaction.dart'
    as add_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/update_transaction.dart'
    as update_transaction;
import 'package:expense_tracker/features/transaction/domain/usecases/delete_transaction.dart'
    as delete_transaction;
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final get_transactions.GetTransactions getTransactions;
  final add_transaction.AddTransaction addTransaction;
  final update_transaction.UpdateTransaction updateTransaction;
  final delete_transaction.DeleteTransaction deleteTransaction;

  TransactionBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
  }) : super(TransactionInitial()) {
    on<GetTransactions>(_onGetTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onGetTransactions(
    GetTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final result = await getTransactions(NoParams());
      await result.fold(
        (failure) async => emit(TransactionError(failure.toString())),
        (transactions) async => emit(TransactionLoaded(transactions)),
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final result = await addTransaction(event.transaction);
      await result.fold(
        (failure) async => emit(TransactionError(failure.toString())),
        (_) async {
          final transactionsResult = await getTransactions(NoParams());
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
          final transactionsResult = await getTransactions(NoParams());
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
          final transactionsResult = await getTransactions(NoParams());
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
}
