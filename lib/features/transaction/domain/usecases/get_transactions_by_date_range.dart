import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class DateRangeParams {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({
    required this.startDate,
    required this.endDate,
  });
}

class GetTransactionsByDateRange
    implements BaseUseCase<List<Transaction>, DateRangeParams> {
  final TransactionRepository repository;

  GetTransactionsByDateRange(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(
      DateRangeParams params) async {
    try {
      final transactions = await repository.getTransactionsByDateRange(
        params.startDate,
        params.endDate,
      );
      return transactions.fold(
        (failure) => Left(failure),
        (transactions) => Right(transactions),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
