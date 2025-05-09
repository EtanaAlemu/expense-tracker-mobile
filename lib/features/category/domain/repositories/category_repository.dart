import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';

abstract class CategoryRepository {
  // Get all categories (local + remote)
  Future<Either<Failure, List<Category>>> getCategories();

  // Get only local categories
  Future<Either<Failure, List<Category>>> getLocalCategories();

  // Get only remote categories
  Future<Either<Failure, List<Category>>> getRemoteCategories();

  // Get a single category
  Future<Either<Failure, Category?>> getCategory(String id);

  // Add a new category
  Future<Either<Failure, Category>> addCategory(Category category);

  // Update an existing category
  Future<Either<Failure, void>> updateCategory(Category category);

  // Delete a category
  Future<Either<Failure, void>> deleteCategory(Category category);

  // Get categories by type
  Future<Either<Failure, List<Category>>> getCategoriesByType(String type);

  // Local data methods
  Future<Either<Failure, void>> cacheCategory(Category category);
  Future<Either<Failure, void>> cacheCategories(List<Category> categories);

  // Remote data methods
  Future<Either<Failure, Category?>> getRemoteCategory(String id);
  Future<Either<Failure, void>> addRemoteCategory(Category category);
  Future<Either<Failure, void>> updateRemoteCategory(Category category);
  Future<Either<Failure, void>> deleteRemoteCategory(String id);
}
