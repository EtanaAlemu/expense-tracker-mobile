import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';

abstract class TransactionEvent {}

class GetTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  AddTransaction(this.transaction);
}

class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;

  UpdateTransaction(this.transaction);
}

class DeleteTransaction extends TransactionEvent {
  final Transaction transaction;

  DeleteTransaction(this.transaction);
}

class SyncTransactions extends TransactionEvent {}
