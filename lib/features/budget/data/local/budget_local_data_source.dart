import 'package:expense_tracker/core/data/local/hive_local_data_source.dart';
import 'package:expense_tracker/features/budget/data/models/hive_budget_model.dart';

class BudgetLocalDataSource extends HiveLocalDataSource<HiveBudgetModel> {
  BudgetLocalDataSource() : super('budgets');

  @override
  String getId(HiveBudgetModel item) => item.id;
}
