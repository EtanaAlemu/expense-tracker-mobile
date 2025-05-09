import 'package:expense_tracker/core/data/local/hive_local_data_source.dart';
import 'package:expense_tracker/features/expense/data/models/hive_expense_model.dart';

class ExpenseLocalDataSource extends HiveLocalDataSource<HiveExpenseModel> {
  ExpenseLocalDataSource() : super('expenses');

  @override
  String getId(HiveExpenseModel item) => item.id;
}
