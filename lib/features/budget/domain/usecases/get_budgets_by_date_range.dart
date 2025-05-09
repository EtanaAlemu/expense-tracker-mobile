import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';

class DateRangeParams {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({
    required this.startDate,
    required this.endDate,
  });
}

class GetBudgetsByDateRange
    implements BaseUseCase<List<Budget>, DateRangeParams> {
  final BudgetRepository repository;

  GetBudgetsByDateRange(this.repository);

  @override
  Future<Either<Failure, List<Budget>>> call(DateRangeParams params) async {
    try {
      final budgets = await repository.getBudgetsByDateRange(
        params.startDate,
        params.endDate,
      );
      return Right(budgets);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
