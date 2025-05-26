import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';

class AddCategory implements BaseUseCase<Category, Params> {
  final CategoryRepository repository;

  AddCategory(this.repository);

  @override
  Future<Either<Failure, Category>> call(Params params) async {
    try {
      return await repository.addCategory(params.category);
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
