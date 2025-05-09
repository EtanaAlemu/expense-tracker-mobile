import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';

class GetBudgetsByCategory implements BaseUseCase<List<Budget>, String> {
  final BudgetRepository repository;

  GetBudgetsByCategory(this.repository);

  @override
  Future<Either<Failure, List<Budget>>> call(String categoryId) async {
    try {
      final budgets = await repository.getBudgetsByCategory(categoryId);
      return Right(budgets);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
