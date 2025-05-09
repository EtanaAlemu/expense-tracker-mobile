import 'package:expense_tracker/features/transaction/data/models/hive_transaction_model.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';

class TransactionMapper {
  HiveTransactionModel toHiveModel(Transaction transaction) {
    return HiveTransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      amount: transaction.amount,
      description: transaction.description,
      type: transaction.type,
      categoryId: transaction.categoryId,
      date: transaction.date,
      isSynced: transaction.isSynced,
    );
  }

  Transaction toEntity(dynamic model) {
    if (model is HiveTransactionModel) {
      return Transaction(
        id: model.id,
        userId: model.userId,
        amount: model.amount,
        description: model.description,
        type: model.type,
        categoryId: model.categoryId,
        date: model.date,
        isSynced: model.isSynced,
      );
    } else if (model is Map<String, dynamic>) {
      return Transaction(
        id: model['_id']?.toString() ?? '',
        userId: model['user']?.toString() ?? '',
        amount: model['amount']?.toDouble() ?? 0.0,
        description: model['description'] ?? '',
        type: model['type'] ?? '',
        categoryId: model['category']?.toString() ?? '',
        date: model['date'] != null
            ? DateTime.parse(model['date'])
            : DateTime.now(),
        isSynced: true,
      );
    }
    throw Exception('Invalid model type');
  }

  // toApiModel
  Map<String, dynamic> toApiModel(Transaction transaction) {
    return {
      'id': transaction.id,
      'userId': transaction.userId,
      'type': transaction.type,
      'amount': transaction.amount,
      'categoryId': transaction.categoryId,
      'description': transaction.description,
      'date': transaction.date,
      'isSynced': transaction.isSynced,
    };
  }

  // toJson
  Map<String, dynamic> toJson(Transaction transaction) {
    return {
      'id': transaction.id,
      'user': transaction.userId,
      'amount': transaction.amount,
      'description': transaction.description,
      'type': transaction.type,
      'category': transaction.categoryId,
      'date': transaction.date.toIso8601String(),
      'isSynced': transaction.isSynced,
    };
  }
}
