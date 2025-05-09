import 'package:expense_tracker/features/budget/data/models/hive_budget_model.dart';
import 'package:expense_tracker/features/budget/domain/entities/budget.dart';

class BudgetMapper {
  HiveBudgetModel toHiveModel(Budget budget) {
    return HiveBudgetModel(
      id: budget.id,
      userId: budget.userId,
      categoryId: budget.categoryId,
      limit: budget.limit,
      startDate: budget.startDate,
      endDate: budget.endDate,
      isSynced: budget.isSynced,
    );
  }

  Budget toEntity(HiveBudgetModel model) {
    return Budget(
      id: model.id,
      userId: model.userId,
      categoryId: model.categoryId,
      limit: model.limit,
      startDate: model.startDate,
      endDate: model.endDate,
      isSynced: model.isSynced,
    );
  }
}
 