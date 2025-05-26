import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';

class DeleteCategory implements BaseUseCase<void, Params> {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    try {
      await repository.deleteCategory(params.category, params.userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class Params {
  final Category category;
  final String userId;
  
  Params({required this.category, required this.userId});
}
