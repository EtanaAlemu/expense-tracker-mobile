import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_categories.dart';
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:expense_tracker/core/services/connectivity/connectivity_service.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/sync_transactions.dart';
import 'package:expense_tracker/features/category/domain/usecases/sync_categories.dart';
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

@module
abstract class ConnectivityModule {
  @Named('connectivityService')
  @singleton
  ConnectivityService connectivityService(
    InternetConnectionChecker connectionChecker,
    SyncTransactions syncTransactions,
    SyncCategories syncCategories,
    GetBudgets getBudgets,
    GetCategories getCategories,
    AppLocalizations l10n,
    AuthRepository authRepository,
    TransactionRepository transactionRepository,
  ) =>
      ConnectivityService(
        connectionChecker: connectionChecker,
        syncTransactions: syncTransactions,
        syncCategories: syncCategories,
        getBudgets: getBudgets,
        getCategories: getCategories,
        l10n: l10n,
        authRepository: authRepository,
        transactionRepository: transactionRepository,
      );
}
