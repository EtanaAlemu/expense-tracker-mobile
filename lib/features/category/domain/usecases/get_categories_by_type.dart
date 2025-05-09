import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';

class GetCategoriesByType implements BaseUseCase<List<Category>, Params> {
  final CategoryRepository repository;

  GetCategoriesByType(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(Params params) async {
    try {
      final categories = await repository.getCategoriesByType(params.type);
      return categories.fold(
        (failure) => Left(failure),
        (categories) => Right(categories),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

class Params {
  final String type;

  Params({required this.type});
}
