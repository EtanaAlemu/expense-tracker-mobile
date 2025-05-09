import 'package:expense_tracker/core/domain/repositories/base_repository.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';

abstract class ExpenseRepository extends BaseRepository<Expense> {
  Future<List<Expense>> getExpensesByCategory(String categoryId);
  Future<List<Expense>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<double> getTotalExpensesByCategory(String categoryId);
  Future<double> getTotalExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
