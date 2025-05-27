import 'dart:async';
import 'package:expense_tracker/features/category/domain/usecases/get_categories.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/sync_transactions.dart';
import 'package:expense_tracker/features/category/domain/usecases/sync_categories.dart';
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/features/category/domain/entities/category.dart';
import 'package:expense_tracker/features/transaction/domain/entities/transaction.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';

@singleton
class ConnectivityService {
  final InternetConnectionChecker _connectionChecker;
  final SyncTransactions _syncTransactions;
  final SyncCategories _syncCategories;
  final GetBudgets _getBudgets;
  final GetCategories _getCategories;
  final AppLocalizations _l10n;
  final AuthRepository _authRepository;
  final TransactionRepository _transactionRepository;
  StreamSubscription<InternetConnectionStatus>? _subscription;
  bool _isSyncing = false;

  ConnectivityService({
    required InternetConnectionChecker connectionChecker,
    required SyncTransactions syncTransactions,
    required SyncCategories syncCategories,
    required GetBudgets getBudgets,
    required GetCategories getCategories,
    required AppLocalizations l10n,
    required AuthRepository authRepository,
    required TransactionRepository transactionRepository,
  })  : _connectionChecker = connectionChecker,
        _syncTransactions = syncTransactions,
        _syncCategories = syncCategories,
        _getBudgets = getBudgets,
        _getCategories = getCategories,
        _l10n = l10n,
        _authRepository = authRepository,
        _transactionRepository = transactionRepository;

  Future<void> initialize() async {
    print('🔄 Initializing ConnectivityService...');

    final status = await _connectionChecker.connectionStatus;
    print('🌐 Initial connection status: $status');

    // Check initial connection status
    if (status == InternetConnectionStatus.connected) {
      print('✅ Connected to internet, starting sync');
      syncData();
    }

    // Listen for connection changes
    _subscription =
        _connectionChecker.onStatusChange.listen(_handleConnectionChange);
  }

  void _handleConnectionChange(InternetConnectionStatus status) {
    print('🌐 Connection status changed: $status');
    if (status == InternetConnectionStatus.connected) {
      syncData();
    }
  }

  Future<void> syncData() async {
    if (_isSyncing) {
      print('🔁 Sync already in progress, skipping...');
      return;
    }

    _isSyncing = true;
    try {
      print('🔄 Starting data synchronization...');

      // Add a small delay to ensure user data is cached
      await Future.delayed(const Duration(milliseconds: 500));

      // Get current user ID from AuthRepository
      final userResult = await _authRepository.getCurrentUser();
      final userId = userResult.fold(
        (failure) {
          print('❌ Failed to get current user: ${failure.message}');
          return '';
        },
        (user) => user.id,
      );

      if (userId.isEmpty) {
        print('❌ No user ID available, skipping sync');
        return;
      }

      // Step 1: Sync categories first
      print('📁 Syncing categories...');
      await _syncCategories(NoParams());
      bool categoriesSynced = true;
      try {
        final categoriesResult =
            await _getCategories(UserParams(userId: userId));
        await categoriesResult.fold(
          (failure) async {
            print('⚠️ Failed to get categories: ${failure.message}');
            categoriesSynced = false;
          },
          (categories) async {
            print('✅ Categories fetched successfully');
            await _updateTransactionCategoryIds(categories);
          },
        );
      } catch (e) {
        print('❌ Error fetching categories after sync: $e');
        categoriesSynced = false;
      }

      // Step 2: Sync transactions (regardless of category sync status)
      print('📊 Syncing transactions...');
      final transactionsResult = await _syncTransactions(NoParams());
      transactionsResult.fold(
        (failure) => print('❌ Failed to sync transactions: ${failure.message}'),
        (_) => print('✅ Transactions synced successfully'),
      );

      // Step 3: Sync budgets last (they depend on categories and transactions)
      print('💰 Syncing budgets...');
      final budgetsResult = await _getBudgets(NoParams());
      budgetsResult.fold(
        (failure) => print('❌ Failed to sync budgets: ${failure.message}'),
        (budgets) => print('✅ Synced ${budgets.length} budgets'),
      );

      print('✅ Data synchronization completed');
      if (!categoriesSynced) {
        print(
            '⚠️ Note: Category sync failed, but transaction sync was attempted');
      }
    } catch (e) {
      print('❌ Error during data synchronization: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _updateTransactionCategoryIds(
      List<Category> syncedCategories) async {
    print('🔄 Updating transaction category IDs...');
    try {
      // Get current user ID from AuthRepository
      final userResult = await _authRepository.getCurrentUser();
      final userId = userResult.fold(
        (failure) {
          print('❌ Failed to get current user: ${failure.message}');
          return '';
        },
        (user) => user.id,
      );

      if (userId.isEmpty) {
        print('❌ No user ID available for transaction sync');
        return;
      }

      // Get all local transactions
      final transactionsResult =
          await _transactionRepository.getTransactions(userId);
      final transactions = transactionsResult.fold(
        (failure) {
          print('❌ Failed to get transactions: ${failure.message}');
          return <Transaction>[];
        },
        (transactions) => transactions,
      );

      // Create a map of category names to new category IDs
      final categoryIdMap = <String, String>{};
      for (final category in syncedCategories) {
        categoryIdMap[category.name] = category.id;
      }

      // Update transactions with new category IDs
      for (final transaction in transactions) {
        // Find the category by name from the synced categories
        final category = syncedCategories.firstWhere(
          (c) => c.name == transaction.categoryId,
          orElse: () => syncedCategories.first,
        );

        if (category.id != transaction.categoryId) {
          print(
              '📝 Updating transaction ${transaction.id} category from ${transaction.categoryId} to ${category.id}');
          final updatedTransaction =
              transaction.copyWith(categoryId: category.id);
          await _transactionRepository.updateTransaction(updatedTransaction);
        }
      }
      print('✅ Transaction category IDs updated successfully');
    } catch (e) {
      print('❌ Error updating transaction category IDs: $e');
    }
  }

  Future<void> dispose() async {
    print('🧹 Disposing ConnectivityService...');
    await _subscription?.cancel();
  }
}
