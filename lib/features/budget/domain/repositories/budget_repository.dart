import 'package:expense_tracker/core/domain/repositories/base_repository.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';

abstract class BudgetRepository extends BaseRepository<Budget> {
  Future<List<Budget>> getBudgetsByCategory(String categoryId);
  Future<List<Budget>> getActiveBudgets();
  Future<List<Budget>> getBudgetsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<double> getTotalBudgetByCategory(String categoryId);
}
 