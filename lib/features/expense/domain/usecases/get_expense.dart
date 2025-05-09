import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';

class GetExpense implements BaseUseCase<Expense?, String> {
  final ExpenseRepository repository;

  GetExpense(this.repository);

  @override
  Future<Either<Failure, Expense?>> call(String id) async {
    try {
      final expense = await repository.get(id);
      return Right(expense);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
