import 'package:injectable/injectable.dart';
import 'package:expense_tracker/injection/injection.dart';
import 'package:expense_tracker/features/budget/data/local/budget_local_data_source.dart';
import 'package:expense_tracker/features/budget/data/mappers/budget_mapper.dart';
import 'package:expense_tracker/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart';
import 'package:expense_tracker/features/budget/domain/usecases/add_budget.dart';
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets.dart';
import 'package:expense_tracker/features/budget/domain/usecases/get_budget.dart';
import 'package:expense_tracker/features/budget/domain/usecases/update_budget.dart';
import 'package:expense_tracker/features/budget/domain/usecases/delete_budget.dart';
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets_by_category.dart';
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets_by_date_range.dart';

@module
abstract class BudgetModule {
  @singleton
  BudgetMapper get budgetMapper => BudgetMapper();

  @singleton
  BudgetLocalDataSource get budgetLocalDataSource => BudgetLocalDataSource();

  @singleton
  BudgetRepository get budgetRepository => BudgetRepositoryImpl(
        localDataSource: getIt<BudgetLocalDataSource>(),
        mapper: getIt<BudgetMapper>(),
      );

  @singleton
  AddBudget get addBudget => AddBudget(getIt<BudgetRepository>());

  @singleton
  GetBudgets get getBudgets => GetBudgets(getIt<BudgetRepository>());

  @singleton
  GetBudget get getBudget => GetBudget(getIt<BudgetRepository>());

  @singleton
  UpdateBudget get updateBudget => UpdateBudget(getIt<BudgetRepository>());

  @singleton
  DeleteBudget get deleteBudget => DeleteBudget(getIt<BudgetRepository>());

  @singleton
  GetBudgetsByCategory get getBudgetsByCategory =>
      GetBudgetsByCategory(getIt<BudgetRepository>());

  @singleton
  GetBudgetsByDateRange get getBudgetsByDateRange =>
      GetBudgetsByDateRange(getIt<BudgetRepository>());
}
