import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

class SyncTransactions extends BaseUseCase<void, NoParams> {
  final TransactionRepository repository;

  SyncTransactions(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.syncTransactions();
  }
}
