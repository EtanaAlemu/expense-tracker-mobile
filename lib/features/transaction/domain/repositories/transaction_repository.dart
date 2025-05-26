import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<Transaction>>> getTransactions(String userId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByType(
      String type, String userId);
  Future<Either<Failure, Transaction>> addTransaction(Transaction transaction);
  Future<Either<Failure, Transaction>> updateTransaction(
      Transaction transaction);
  Future<Either<Failure, void>> deleteTransaction(Transaction transaction);
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
    String userId,
  );
  Future<Either<Failure, double>> getTotalTransactionsByType(
      String type, String userId);
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
      String categoryId, String userId);
  Future<Either<Failure, double>> getTotalTransactionsByCategory(
      String categoryId, String userId);
  Future<Either<Failure, double>> getTotalTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
    String userId,
  );
  Future<Either<Failure, void>> syncTransactions();
}
