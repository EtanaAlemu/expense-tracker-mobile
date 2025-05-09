import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';

class DateRangeParams {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({
    required this.startDate,
    required this.endDate,
  });
}

class GetExpensesByDateRange
    implements BaseUseCase<List<Expense>, DateRangeParams> {
  final ExpenseRepository repository;

  GetExpensesByDateRange(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(DateRangeParams params) async {
    try {
      final expenses = await repository.getExpensesByDateRange(
        params.startDate,
        params.endDate,
      );
      return Right(expenses);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
