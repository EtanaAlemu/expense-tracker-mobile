import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';

class AddBudget implements BaseUseCase<void, Budget> {
  final BudgetRepository repository;

  AddBudget(this.repository);

  @override
  Future<Either<Failure, void>> call(Budget budget) async {
    try {
      await repository.save(budget);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
