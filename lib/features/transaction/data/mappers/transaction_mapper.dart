import 'package:expense_tracker/features/transaction/data/models/hive_transaction_model.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';

class TransactionMapper {
  HiveTransactionModel toHiveModel(Transaction transaction) {
    return HiveTransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      amount: transaction.amount,
      title: transaction.title,
      description: transaction.description,
      type: transaction.type,
      categoryId: transaction.categoryId,
      date: transaction.date.toUtc(),
      isSynced: transaction.isSynced,
      isDeleted: transaction.isDeleted,
      isUpdated: transaction.isUpdated,
    );
  }

  Transaction toEntity(dynamic model) {
    if (model is HiveTransactionModel) {
      return Transaction(
        id: model.id,
        userId: model.userId,
        amount: model.amount,
        title: model.title,
        description: model.description,
        type: model.type,
        categoryId: model.categoryId,
        date: model.date.toLocal(),
        isSynced: model.isSynced,
        isDeleted: model.isDeleted,
        isUpdated: model.isUpdated,
      );
    } else if (model is Map<String, dynamic>) {
      DateTime date;
      if (model['date'] != null) {
        if (model['date'] is int) {
          date = DateTime.fromMillisecondsSinceEpoch(model['date'] as int)
              .toLocal();
        } else {
          date = DateTime.parse(model['date'] as String).toLocal();
        }
      } else {
        date = DateTime.now();
      }

      return Transaction(
        id: model['_id']?.toString() ?? '',
        userId: model['user']?.toString() ?? '',
        amount: model['amount']?.toDouble() ?? 0.0,
        title: model['title'] ?? '',
        description: model['description'] ?? '',
        type: model['type'] ?? '',
        categoryId: model['category']?.toString() ?? '',
        date: date,
        isSynced: true,
        isDeleted: false,
        isUpdated: false,
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
      'title': transaction.title,
      'description': transaction.description,
      'date': transaction.date.toUtc().millisecondsSinceEpoch,
      'isSynced': transaction.isSynced,
      'isDeleted': transaction.isDeleted,
      'isUpdated': transaction.isUpdated,
    };
  }

  // toJson
  Map<String, dynamic> toJson(Transaction transaction) {
    return {
      'id': transaction.id,
      'user': transaction.userId,
      'amount': transaction.amount,
      'title': transaction.title,
      'description': transaction.description,
      'type': transaction.type,
      'category': transaction.categoryId,
      'date': transaction.date.toUtc().millisecondsSinceEpoch,
      'isSynced': transaction.isSynced,
      'isDeleted': transaction.isDeleted,
      'isUpdated': transaction.isUpdated,
    };
  }
}
