import 'package:expense_tracker/core/data/local/hive_local_data_source.dart';
import 'package:expense_tracker/features/transaction/data/models/hive_transaction_model.dart';

class TransactionLocalDataSource
    extends HiveLocalDataSource<HiveTransactionModel> {
  TransactionLocalDataSource() : super('transactions');

  @override
  String getId(HiveTransactionModel item) {
    if (item.id.isEmpty) {
      // Generate a unique ID if none exists
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
    return item.id;
  }
}
