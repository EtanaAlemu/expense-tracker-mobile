import 'package:expense_tracker/features/category/domain/entities/category.dart';

abstract class CategoryRemoteDataSource {
  Future<Category> addCategory(Category category);
  Future<Category?> getCategory(String id);
  Future<List<Category>> getCategories();
  Future<List<Category>> getCategoriesByType(String type);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String id);
}
