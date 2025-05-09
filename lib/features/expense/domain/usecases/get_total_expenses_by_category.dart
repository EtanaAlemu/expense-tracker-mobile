import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';

class GetTotalExpensesByCategory implements BaseUseCase<double, String> {
  final ExpenseRepository repository;

  GetTotalExpensesByCategory(this.repository);

  @override
  Future<Either<Failure, double>> call(String categoryId) async {
    try {
      final total = await repository.getTotalExpensesByCategory(categoryId);
      return Right(total);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
