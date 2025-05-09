import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionsByType implements BaseUseCase<List<Transaction>, String> {
  final TransactionRepository repository;

  GetTransactionsByType(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(String type) async {
    try {
      final transactions = await repository.getTransactionsByType(type);
      return transactions.fold(
        (failure) => Left(failure),
        (transactions) => Right(transactions),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
