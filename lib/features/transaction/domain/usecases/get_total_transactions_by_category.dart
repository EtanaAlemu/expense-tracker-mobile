import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class GetTotalTransactionsByCategory implements BaseUseCase<double, String> {
  final TransactionRepository repository;

  GetTotalTransactionsByCategory(this.repository);

  @override
  Future<Either<Failure, double>> call(String categoryId) async {
    try {
      final total = await repository.getTotalTransactionsByCategory(categoryId);
      return total.fold(
        (failure) => Left(failure),
        (total) => Right(total),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
