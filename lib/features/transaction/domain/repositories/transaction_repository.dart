import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions();
  Future<Either<Failure, void>> addTransaction(Transaction transaction);
  Future<Either<Failure, void>> updateTransaction(Transaction transaction);
  Future<Either<Failure, void>> deleteTransaction(Transaction transaction);
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(String type);
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
      String categoryId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Either<Failure, double>> getTotalTransactionsByType(String type);
  Future<Either<Failure, double>> getTotalTransactionsByCategory(
      String categoryId);
  Future<Either<Failure, double>> getTotalTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
