import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';

class GetBudgets implements BaseUseCase<List<Budget>, NoParams> {
  final BudgetRepository repository;

  GetBudgets(this.repository);

  @override
  Future<Either<Failure, List<Budget>>> call(NoParams params) async {
    try {
      final budgets = await repository.getAll();
      return Right(budgets);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
