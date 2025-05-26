import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';

abstract class CategoryRepository {
  // Get all categories (local + remote)
  Future<Either<Failure, List<Category>>> getCategories(String userId);

  // Get a single category
  Future<Either<Failure, Category>> getCategory(String id, String userId);

  // Add a new category
  Future<Either<Failure, Category>> addCategory(Category category);

  // Update an existing category
  Future<Either<Failure, Category>> updateCategory(Category category);

  // Delete a category
  Future<Either<Failure, void>> deleteCategory(Category category, String userId);

  // Get categories by type
  Future<Either<Failure, List<Category>>> getCategoriesByType(String type, String userId);

  Future<Either<Failure, void>> syncCategories();
}
