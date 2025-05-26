import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class TypeParams {
  final String type;
  final String userId;
  const TypeParams({
    required this.type,
    required this.userId,
  });
}

class GetTransactionsByType
    implements BaseUseCase<List<Transaction>, TypeParams> {
  final TransactionRepository repository;

  GetTransactionsByType(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(TypeParams params) async {
    try {
      final transactions = await repository.getTransactionsByType(
          params.type, params.userId);
      return transactions.fold(
        (failure) => Left(failure),
        (transactions) => Right(transactions),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
