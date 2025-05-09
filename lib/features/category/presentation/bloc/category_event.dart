import 'package:expense_tracker/features/category/domain/entities/category.dart';

abstract class CategoryEvent {}

class GetCategories extends CategoryEvent {}

class GetCategory extends CategoryEvent {
  final String id;

  GetCategory(this.id);
}

class AddCategory extends CategoryEvent {
  final Category category;

  AddCategory(this.category);
}

class UpdateCategory extends CategoryEvent {
  final Category category;

  UpdateCategory(this.category);
}

class DeleteCategory extends CategoryEvent {
  final Category category;

  DeleteCategory(this.category);
}

class GetCategoriesByType extends CategoryEvent {
  final String type;

  GetCategoriesByType(this.type);
}
