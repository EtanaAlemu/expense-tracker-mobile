import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/sync_transactions.dart';
import 'package:expense_tracker/features/category/domain/usecases/sync_categories.dart';
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';

@singleton
class ConnectivityService {
  final InternetConnectionChecker _connectionChecker;
  final SyncTransactions _syncTransactions;
  final SyncCategories _syncCategories;
  final GetBudgets _getBudgets;
  final AppLocalizations _l10n;
  final AuthBloc _authBloc;
  StreamSubscription<InternetConnectionStatus>? _subscription;
  bool _isSyncing = false;

  ConnectivityService({
    required InternetConnectionChecker connectionChecker,
    required SyncTransactions syncTransactions,
    required SyncCategories syncCategories,
    required GetBudgets getBudgets,
    required AppLocalizations l10n,
    required AuthBloc authBloc,
  })  : _connectionChecker = connectionChecker,
        _syncTransactions = syncTransactions,
        _syncCategories = syncCategories,
        _getBudgets = getBudgets,
        _l10n = l10n,
        _authBloc = authBloc;

  Future<void> initialize() async {
    print('🔄 Initializing ConnectivityService...');

    final status = await _connectionChecker.connectionStatus;
    print('🌐 Initial connection status: $status');

    // Check initial connection status
    if (status == InternetConnectionStatus.connected) {
      print('✅ Connected to internet, starting sync');
      _syncData();
    }

    // Listen for connection changes
    _subscription =
        _connectionChecker.onStatusChange.listen(_handleConnectionChange);
  }

  void _handleConnectionChange(InternetConnectionStatus status) {
    print('🌐 Connection status changed: $status');
    if (status == InternetConnectionStatus.connected) {
      _syncData();
    }
  }

  Future<void> _syncData() async {
    if (_isSyncing) {
      print('🔁 Sync already in progress, skipping...');
      return;
    }

    _isSyncing = true;
    try {
      print('🔄 Starting data synchronization...');

      // Step 1: Sync categories first
      print('📁 Syncing categories...');
      final categoriesResult = await _syncCategories(NoParams());
      final categoriesSynced = categoriesResult.fold(
        (failure) {
          print('⚠️ Failed to sync categories: ${failure.message}');
          return false;
        },
        (_) {
          print('✅ Categories synced successfully');
          return true;
        },
      );

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

  Future<void> dispose() async {
    print('🧹 Disposing ConnectivityService...');
    await _subscription?.cancel();
  }
}
