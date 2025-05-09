import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';

class GetCategory implements BaseUseCase<Category?, Params> {
  final CategoryRepository repository;

  GetCategory(this.repository);

  @override
  Future<Either<Failure, Category?>> call(Params params) async {
    try {
      final category = await repository.getCategory(params.id);
      return category.fold(
        (failure) => Left(failure),
        (category) => Right(category),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class Params {
  final String id;

  Params({required this.id});
}
