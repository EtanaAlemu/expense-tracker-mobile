import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';

class SyncCategories implements BaseUseCase<void, NoParams> {
  final CategoryRepository repository;

  SyncCategories(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      return await repository.syncCategories();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
