import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class CategoryParams {
  final String categoryId;
  final String userId;
  const CategoryParams({
    required this.categoryId,
    required this.userId,
  });
}

class GetTransactionsByCategory
    implements BaseUseCase<List<Transaction>, CategoryParams> {
  final TransactionRepository repository;

  GetTransactionsByCategory(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(CategoryParams params) async {
    try {
      final transactions = await repository.getTransactionsByCategory(
          params.categoryId, params.userId);
      return transactions.fold(
        (failure) => Left(failure),
        (transactions) => Right(transactions),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
