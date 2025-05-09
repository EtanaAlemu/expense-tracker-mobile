import 'package:expense_tracker/features/expense/data/models/hive_expense_model.dart';
import 'package:expense_tracker/features/expense/domain/entities/expense.dart';

class ExpenseMapper {
  HiveExpenseModel toHiveModel(Expense expense) {
    return HiveExpenseModel(
      id: expense.id,
      userId: expense.userId,
      amount: expense.amount,
      categoryId: expense.categoryId,
      description: expense.description,
      date: expense.date,
      isSynced: expense.isSynced,
    );
  }

  Expense toEntity(HiveExpenseModel model) {
    return Expense(
      id: model.id,
      userId: model.userId,
      amount: model.amount,
      categoryId: model.categoryId,
      description: model.description,
      date: model.date,
      isSynced: model.isSynced,
    );
  }
}
 