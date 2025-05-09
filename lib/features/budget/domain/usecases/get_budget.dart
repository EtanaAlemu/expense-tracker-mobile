import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';

class GetBudget implements BaseUseCase<Budget?, String> {
  final BudgetRepository repository;

  GetBudget(this.repository);

  @override
  Future<Either<Failure, Budget?>> call(String id) async {
    try {
      final budget = await repository.get(id);
      return Right(budget);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
