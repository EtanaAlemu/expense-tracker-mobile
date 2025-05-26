import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class CategoryParams {
  final String categoryId;
  final String userId;
  const CategoryParams({
    required this.categoryId,
    required this.userId,
  });
}

class GetTotalTransactionsByCategory
    implements BaseUseCase<double, CategoryParams> {
  final TransactionRepository repository;

  GetTotalTransactionsByCategory(this.repository);

  @override
  Future<Either<Failure, double>> call(CategoryParams params) async {
    try {
      final total = await repository.getTotalTransactionsByCategory(
          params.categoryId, params.userId);

      return total.fold(
        (failure) => Left(failure),
        (total) => Right(total),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
