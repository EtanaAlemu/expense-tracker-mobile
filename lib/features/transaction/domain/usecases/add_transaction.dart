import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class AddTransaction implements BaseUseCase<Transaction, Transaction> {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  @override
  Future<Either<Failure, Transaction>> call(Transaction transaction) async {
    try {
      final result = await repository.addTransaction(transaction);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
