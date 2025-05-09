import 'package:injectable/injectable.dart';
import 'package:expense_tracker/injection/injection.dart';
import 'package:expense_tracker/features/expense/data/local/expense_local_data_source.dart';
import 'package:expense_tracker/features/expense/data/mappers/expense_mapper.dart';
import 'package:expense_tracker/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expense/domain/usecases/add_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_expenses.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_expenses_by_category.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_total_expenses_by_category.dart';
import 'package:expense_tracker/features/expense/domain/usecases/get_expenses_by_date_range.dart';
import 'package:expense_tracker/features/expense/domain/usecases/update_expense.dart';
import 'package:expense_tracker/features/expense/domain/usecases/delete_expense.dart';

@module
abstract class ExpenseModule {
  @singleton
  ExpenseMapper get expenseMapper => ExpenseMapper();

  @singleton
  ExpenseLocalDataSource get expenseLocalDataSource => ExpenseLocalDataSource();

  @singleton
  ExpenseRepository get expenseRepository => ExpenseRepositoryImpl(
        localDataSource: getIt<ExpenseLocalDataSource>(),
        mapper: getIt<ExpenseMapper>(),
      );

  @singleton
  AddExpense get addExpense => AddExpense(getIt<ExpenseRepository>());

  @singleton
  GetExpenses get getExpenses => GetExpenses(getIt<ExpenseRepository>());

  @singleton
  GetExpense get getExpense => GetExpense(getIt<ExpenseRepository>());

  @singleton
  GetExpensesByCategory get getExpensesByCategory =>
      GetExpensesByCategory(getIt<ExpenseRepository>());

  @singleton
  GetTotalExpensesByCategory get getTotalExpensesByCategory =>
      GetTotalExpensesByCategory(getIt<ExpenseRepository>());

  @singleton
  GetExpensesByDateRange get getExpensesByDateRange =>
      GetExpensesByDateRange(getIt<ExpenseRepository>());

  @singleton
  UpdateExpense get updateExpense => UpdateExpense(getIt<ExpenseRepository>());

  @singleton
  DeleteExpense get deleteExpense => DeleteExpense(getIt<ExpenseRepository>());
}
