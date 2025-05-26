import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart';

class GetCategories implements BaseUseCase<List<Category>, UserParams> {
  final CategoryRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(UserParams params) async {
    return repository.getCategories(params.userId);
  }
}
