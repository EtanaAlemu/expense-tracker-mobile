// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;

import '../core/di/core_module.dart' as _i747;
import '../core/network/api_service.dart' as _i1003;
import '../core/network/interceptors/auth_interceptor.dart' as _i790;
import '../core/network/network_info.dart' as _i6;
import '../features/auth/data/datasources/local/auth_local_data_source.dart'
    as _i148;
import '../features/auth/data/datasources/remote/auth_remote_data_source.dart'
    as _i236;
import '../features/auth/data/models/hive_user_model.dart' as _i1030;
import '../features/auth/di/auth_module.dart' as _i84;
import '../features/auth/domain/repositories/auth_repository.dart' as _i869;
import '../features/auth/domain/usecases/change_password_usecase.dart' as _i59;
import '../features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i403;
import '../features/auth/domain/usecases/forgot_password_usecase.dart' as _i532;
import '../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i634;
import '../features/auth/domain/usecases/get_token_usecase.dart' as _i901;
import '../features/auth/domain/usecases/is_signed_in_usecase.dart' as _i1032;
import '../features/auth/domain/usecases/reset_password_usecase.dart' as _i685;
import '../features/auth/domain/usecases/sign_in_usecase.dart' as _i594;
import '../features/auth/domain/usecases/sign_out_usecase.dart' as _i190;
import '../features/auth/domain/usecases/sign_up_usecase.dart' as _i797;
import '../features/auth/domain/usecases/update_user_usecase.dart' as _i625;
import '../features/auth/domain/usecases/validate_token_usecase.dart' as _i461;
import '../features/auth/presentation/bloc/auth_bloc.dart' as _i59;
import '../features/budget/data/local/budget_local_data_source.dart' as _i495;
import '../features/budget/data/mappers/budget_mapper.dart' as _i793;
import '../features/budget/di/budget_module.dart' as _i663;
import '../features/budget/domain/repositories/budget_repository.dart' as _i980;
import '../features/budget/domain/usecases/add_budget.dart' as _i588;
import '../features/budget/domain/usecases/delete_budget.dart' as _i641;
import '../features/budget/domain/usecases/get_budget.dart' as _i35;
import '../features/budget/domain/usecases/get_budgets.dart' as _i631;
import '../features/budget/domain/usecases/get_budgets_by_category.dart'
    as _i65;
import '../features/budget/domain/usecases/get_budgets_by_date_range.dart'
    as _i187;
import '../features/budget/domain/usecases/update_budget.dart' as _i293;
import '../features/category/data/local/category_local_data_source.dart'
    as _i1022;
import '../features/category/data/mappers/category_mapper.dart' as _i335;
import '../features/category/data/remote/category_remote_data_source.dart'
    as _i34;
import '../features/category/di/category_module.dart' as _i560;
import '../features/category/domain/repositories/category_repository.dart'
    as _i914;
import '../features/category/domain/usecases/add_category.dart' as _i806;
import '../features/category/domain/usecases/delete_category.dart' as _i1052;
import '../features/category/domain/usecases/get_categories.dart' as _i156;
import '../features/category/domain/usecases/get_categories_by_type.dart'
    as _i202;
import '../features/category/domain/usecases/get_category.dart' as _i508;
import '../features/category/domain/usecases/update_category.dart' as _i1011;
import '../features/category/presentation/bloc/category_bloc.dart' as _i1016;
import '../features/expense/data/local/expense_local_data_source.dart' as _i642;
import '../features/expense/data/mappers/expense_mapper.dart' as _i370;
import '../features/expense/di/expense_module.dart' as _i87;
import '../features/expense/domain/repositories/expense_repository.dart'
    as _i396;
import '../features/expense/domain/usecases/add_expense.dart' as _i918;
import '../features/expense/domain/usecases/delete_expense.dart' as _i191;
import '../features/expense/domain/usecases/get_expense.dart' as _i299;
import '../features/expense/domain/usecases/get_expenses.dart' as _i502;
import '../features/expense/domain/usecases/get_expenses_by_category.dart'
    as _i989;
import '../features/expense/domain/usecases/get_expenses_by_date_range.dart'
    as _i190;
import '../features/expense/domain/usecases/get_total_expenses_by_category.dart'
    as _i978;
import '../features/expense/domain/usecases/update_expense.dart' as _i573;
import '../features/transaction/data/local/transaction_local_data_source.dart'
    as _i129;
import '../features/transaction/data/mappers/transaction_mapper.dart' as _i1046;
import '../features/transaction/data/remote/transaction_remote_data_source.dart'
    as _i550;
import '../features/transaction/di/transaction_module.dart' as _i697;
import '../features/transaction/domain/repositories/transaction_repository.dart'
    as _i119;
import '../features/transaction/domain/usecases/add_transaction.dart' as _i786;
import '../features/transaction/domain/usecases/delete_transaction.dart'
    as _i365;
import '../features/transaction/domain/usecases/get_total_transactions_by_category.dart'
    as _i898;
import '../features/transaction/domain/usecases/get_transactions.dart' as _i56;
import '../features/transaction/domain/usecases/get_transactions_by_category.dart'
    as _i808;
import '../features/transaction/domain/usecases/get_transactions_by_date_range.dart'
    as _i961;
import '../features/transaction/domain/usecases/get_transactions_by_type.dart'
    as _i558;
import '../features/transaction/domain/usecases/update_transaction.dart'
    as _i877;
import '../features/transaction/presentation/bloc/transaction_bloc.dart'
    as _i81;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final categoryModule = _$CategoryModule();
    final expenseModule = _$ExpenseModule();
    final budgetModule = _$BudgetModule();
    final transactionModule = _$TransactionModule();
    final coreModule = _$CoreModule();
    final authModule = _$AuthModule();
    gh.factory<_i790.AuthInterceptor>(() => _i790.AuthInterceptor());
    gh.singleton<_i335.CategoryMapper>(() => categoryModule.categoryMapper());
    gh.singleton<_i1022.CategoryLocalDataSource>(
        () => categoryModule.categoryLocalDataSource());
    gh.singleton<_i370.ExpenseMapper>(() => expenseModule.expenseMapper);
    gh.singleton<_i642.ExpenseLocalDataSource>(
        () => expenseModule.expenseLocalDataSource);
    gh.singleton<_i396.ExpenseRepository>(
        () => expenseModule.expenseRepository);
    gh.singleton<_i918.AddExpense>(() => expenseModule.addExpense);
    gh.singleton<_i502.GetExpenses>(() => expenseModule.getExpenses);
    gh.singleton<_i299.GetExpense>(() => expenseModule.getExpense);
    gh.singleton<_i989.GetExpensesByCategory>(
        () => expenseModule.getExpensesByCategory);
    gh.singleton<_i978.GetTotalExpensesByCategory>(
        () => expenseModule.getTotalExpensesByCategory);
    gh.singleton<_i190.GetExpensesByDateRange>(
        () => expenseModule.getExpensesByDateRange);
    gh.singleton<_i573.UpdateExpense>(() => expenseModule.updateExpense);
    gh.singleton<_i191.DeleteExpense>(() => expenseModule.deleteExpense);
    gh.singleton<_i793.BudgetMapper>(() => budgetModule.budgetMapper);
    gh.singleton<_i495.BudgetLocalDataSource>(
        () => budgetModule.budgetLocalDataSource);
    gh.singleton<_i980.BudgetRepository>(() => budgetModule.budgetRepository);
    gh.singleton<_i588.AddBudget>(() => budgetModule.addBudget);
    gh.singleton<_i631.GetBudgets>(() => budgetModule.getBudgets);
    gh.singleton<_i35.GetBudget>(() => budgetModule.getBudget);
    gh.singleton<_i293.UpdateBudget>(() => budgetModule.updateBudget);
    gh.singleton<_i641.DeleteBudget>(() => budgetModule.deleteBudget);
    gh.singleton<_i65.GetBudgetsByCategory>(
        () => budgetModule.getBudgetsByCategory);
    gh.singleton<_i187.GetBudgetsByDateRange>(
        () => budgetModule.getBudgetsByDateRange);
    gh.singleton<_i1046.TransactionMapper>(
        () => transactionModule.transactionMapper());
    gh.singleton<_i129.TransactionLocalDataSource>(
        () => transactionModule.transactionLocalDataSource());
    gh.singleton<_i361.Dio>(() => coreModule.dio);
    gh.singleton<_i973.InternetConnectionChecker>(
        () => coreModule.connectionChecker());
    await gh.factoryAsync<_i986.Box<_i1030.HiveUserModel>>(
      () => coreModule.userBox(),
      instanceName: 'users',
      preResolve: true,
    );
    gh.singleton<_i6.NetworkInfo>(
        () => coreModule.networkInfo(gh<_i973.InternetConnectionChecker>()));
    await gh.factoryAsync<_i986.Box<String>>(
      () => coreModule.tokenBox(),
      instanceName: 'tokens',
      preResolve: true,
    );
    gh.singleton<_i148.AuthLocalDataSource>(
        () => authModule.authLocalDataSource(
              gh<_i986.Box<_i1030.HiveUserModel>>(instanceName: 'users'),
              gh<_i986.Box<String>>(instanceName: 'tokens'),
            ));
    await gh.singletonAsync<_i1003.ApiService>(
      () => coreModule.apiService(
        gh<_i361.Dio>(),
        gh<_i986.Box<String>>(instanceName: 'tokens'),
      ),
      preResolve: true,
    );
    gh.singleton<_i34.CategoryRemoteDataSource>(
        () => categoryModule.categoryRemoteDataSource(
              gh<_i1003.ApiService>(),
              gh<_i335.CategoryMapper>(),
            ));
    gh.singleton<_i550.TransactionRemoteDataSource>(
        () => transactionModule.transactionRemoteDataSource(
              gh<_i1003.ApiService>(),
              gh<_i1046.TransactionMapper>(),
            ));
    gh.singleton<_i119.TransactionRepository>(
        () => transactionModule.transactionRepository(
              gh<_i129.TransactionLocalDataSource>(),
              gh<_i550.TransactionRemoteDataSource>(),
              gh<_i1046.TransactionMapper>(),
              gh<_i6.NetworkInfo>(),
            ));
    gh.singleton<_i236.AuthRemoteDataSource>(
        () => authModule.authRemoteDataSource(gh<_i1003.ApiService>()));
    gh.singleton<_i869.AuthRepository>(() => authModule.authRepository(
          gh<_i236.AuthRemoteDataSource>(),
          gh<_i148.AuthLocalDataSource>(),
          gh<_i6.NetworkInfo>(),
          gh<_i1003.ApiService>(),
        ));
    gh.singleton<_i914.CategoryRepository>(
        () => categoryModule.categoryRepository(
              gh<_i1022.CategoryLocalDataSource>(),
              gh<_i34.CategoryRemoteDataSource>(),
              gh<_i335.CategoryMapper>(),
              gh<_i6.NetworkInfo>(),
            ));
    gh.factory<_i403.CheckAuthStatusUseCase>(
        () => _i403.CheckAuthStatusUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i594.SignInUseCase>(
        () => authModule.signInUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i797.SignUpUseCase>(
        () => authModule.signUpUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i190.SignOutUseCase>(
        () => authModule.signOutUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i59.ChangePasswordUseCase>(
        () => authModule.changePasswordUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i625.UpdateUserUseCase>(
        () => authModule.updateUserUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i685.ResetPasswordUseCase>(
        () => authModule.resetPasswordUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i532.ForgotPasswordUseCase>(
        () => authModule.forgotPasswordUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i634.GetCurrentUserUseCase>(
        () => authModule.getCurrentUserUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i1032.IsSignedInUseCase>(
        () => authModule.isSignedInUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i901.GetTokenUseCase>(
        () => authModule.getTokenUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i461.ValidateTokenUseCase>(
        () => authModule.validateTokenUseCase(gh<_i869.AuthRepository>()));
    gh.singleton<_i806.AddCategory>(() =>
        categoryModule.addCategoryUseCase(gh<_i914.CategoryRepository>()));
    gh.singleton<_i156.GetCategories>(
        () => categoryModule.getCategories(gh<_i914.CategoryRepository>()));
    gh.singleton<_i508.GetCategory>(
        () => categoryModule.getCategory(gh<_i914.CategoryRepository>()));
    gh.singleton<_i1011.UpdateCategory>(
        () => categoryModule.updateCategory(gh<_i914.CategoryRepository>()));
    gh.singleton<_i1052.DeleteCategory>(
        () => categoryModule.deleteCategory(gh<_i914.CategoryRepository>()));
    gh.singleton<_i202.GetCategoriesByType>(() =>
        categoryModule.getCategoriesByType(gh<_i914.CategoryRepository>()));
    gh.singleton<_i786.AddTransaction>(() =>
        transactionModule.addTransaction(gh<_i119.TransactionRepository>()));
    gh.singleton<_i56.GetTransactions>(() =>
        transactionModule.getTransactions(gh<_i119.TransactionRepository>()));
    gh.singleton<_i558.GetTransactionsByType>(() => transactionModule
        .getTransactionsByType(gh<_i119.TransactionRepository>()));
    gh.singleton<_i877.UpdateTransaction>(() =>
        transactionModule.updateTransaction(gh<_i119.TransactionRepository>()));
    gh.singleton<_i365.DeleteTransaction>(() =>
        transactionModule.deleteTransaction(gh<_i119.TransactionRepository>()));
    gh.singleton<_i961.GetTransactionsByDateRange>(() => transactionModule
        .getTransactionsByDateRange(gh<_i119.TransactionRepository>()));
    gh.singleton<_i808.GetTransactionsByCategory>(() => transactionModule
        .getTransactionsByCategory(gh<_i119.TransactionRepository>()));
    gh.singleton<_i898.GetTotalTransactionsByCategory>(() => transactionModule
        .getTotalTransactionsByCategory(gh<_i119.TransactionRepository>()));
    gh.factory<_i1016.CategoryBloc>(() => categoryModule.categoryBloc(
          gh<_i156.GetCategories>(),
          gh<_i508.GetCategory>(),
          gh<_i806.AddCategory>(),
          gh<_i1011.UpdateCategory>(),
          gh<_i1052.DeleteCategory>(),
          gh<_i202.GetCategoriesByType>(),
        ));
    gh.factory<_i59.AuthBloc>(() => _i59.AuthBloc(
          gh<_i594.SignInUseCase>(),
          gh<_i190.SignOutUseCase>(),
          gh<_i403.CheckAuthStatusUseCase>(),
          gh<_i797.SignUpUseCase>(),
          gh<_i625.UpdateUserUseCase>(),
          gh<_i59.ChangePasswordUseCase>(),
          gh<_i685.ResetPasswordUseCase>(),
          gh<_i532.ForgotPasswordUseCase>(),
          gh<_i901.GetTokenUseCase>(),
          gh<_i461.ValidateTokenUseCase>(),
        ));
    gh.singleton<_i81.TransactionBloc>(() => transactionModule.transactionBloc(
          gh<_i56.GetTransactions>(),
          gh<_i786.AddTransaction>(),
          gh<_i877.UpdateTransaction>(),
          gh<_i365.DeleteTransaction>(),
        ));
    return this;
  }
}

class _$CategoryModule extends _i560.CategoryModule {}

class _$ExpenseModule extends _i87.ExpenseModule {}

class _$BudgetModule extends _i663.BudgetModule {}

class _$TransactionModule extends _i697.TransactionModule {}

class _$CoreModule extends _i747.CoreModule {}

class _$AuthModule extends _i84.AuthModule {}
