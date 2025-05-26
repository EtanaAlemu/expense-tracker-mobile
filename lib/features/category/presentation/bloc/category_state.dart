import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<Category>? categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String? error;
  final List<Category>? previousCategories;

  const CategoryError(this.error, {this.previousCategories});

  @override
  List<Object?> get props => [error, previousCategories];
}
