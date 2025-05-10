import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/features/auth/data/models/hive_user_model.dart';
import 'package:expense_tracker/features/budget/data/models/hive_budget_model.dart';
import 'package:expense_tracker/features/category/data/models/hive_category_model.dart';
import 'package:expense_tracker/features/expense/data/models/hive_expense_model.dart';
import 'package:expense_tracker/features/transaction/data/models/hive_transaction_model.dart';

class HiveRegistry {
  static Box<HiveUserModel>? _userBox;
  static Box<String>? _tokenBox;
  static Box<bool>? _preferencesBox;
  static Box<HiveBudgetModel>? _budgetBox;
  static Box<HiveCategoryModel>? _categoryBox;
  static Box<HiveExpenseModel>? _expenseBox;
  static Box<HiveTransactionModel>? _transactionBox;
  static bool _isInitialized = false;

  static Future<void> registerAdapters() async {
    if (!_isInitialized) {
      // Register all Hive adapters
      Hive.registerAdapter(HiveUserModelAdapter());
      Hive.registerAdapter(HiveBudgetModelAdapter());
      Hive.registerAdapter(HiveCategoryModelAdapter());
      Hive.registerAdapter(HiveTransactionModelAdapter());
      Hive.registerAdapter(HiveExpenseModelAdapter());
      _isInitialized = true;
    }
  }

  static Future<void> initialize([String? path]) async {
    if (path != null) {
      await Hive.initFlutter(path);
    } else {
      await Hive.initFlutter();
    }
    await registerAdapters();

    // Open boxes with proper types
    _userBox = await Hive.openBox<HiveUserModel>('users');
    _tokenBox = await Hive.openBox<String>('tokens');
    _preferencesBox = await Hive.openBox<bool>('preferences');
    _budgetBox = await Hive.openBox<HiveBudgetModel>('budgets');
    _categoryBox = await Hive.openBox<HiveCategoryModel>('categories');
    _expenseBox = await Hive.openBox<HiveExpenseModel>('expenses');
    _transactionBox = await Hive.openBox<HiveTransactionModel>('transactions');
  }

  static Box<HiveUserModel> get userBox => _getBox(_userBox, 'users');
  static Box<String> get tokenBox => _getBox(_tokenBox, 'tokens');
  static Box<bool> get preferencesBox =>
      _getBox(_preferencesBox, 'preferences');
  static Box<HiveBudgetModel> get budgetBox => _getBox(_budgetBox, 'budgets');
  static Box<HiveCategoryModel> get categoryBox =>
      _getBox(_categoryBox, 'categories');
  static Box<HiveExpenseModel> get expenseBox =>
      _getBox(_expenseBox, 'expenses');
  static Box<HiveTransactionModel> get transactionBox =>
      _getBox(_transactionBox, 'transactions');

  static Box<T> _getBox<T>(Box<T>? box, String name) {
    if (box == null) {
      throw Exception('Hive not initialized. Call initialize() first.');
    }
    return box;
  }
}
