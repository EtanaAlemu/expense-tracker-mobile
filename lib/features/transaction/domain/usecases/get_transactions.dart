import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';


class GetTransactions implements BaseUseCase<List<Transaction>, UserParams> {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(UserParams params) async {
    try {
      final transactions = await repository.getTransactions(params.userId);
      return transactions.fold(
        (failure) => Left(failure),
        (transactions) => Right(transactions),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
