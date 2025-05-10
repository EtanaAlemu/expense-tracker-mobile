// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:expense_tracker/core/di/core_module.dart' as _i370;
import 'package:expense_tracker/core/network/api_service.dart' as _i102;
import 'package:expense_tracker/core/network/interceptors/auth_interceptor.dart'
    as _i43;
import 'package:expense_tracker/core/network/network_info.dart' as _i721;
import 'package:expense_tracker/core/presentation/bloc/theme_bloc.dart'
    as _i986;
import 'package:expense_tracker/core/services/theme/theme_service.dart'
    as _i225;
import 'package:expense_tracker/features/auth/data/datasources/local/auth_local_data_source.dart'
    as _i615;
import 'package:expense_tracker/features/auth/data/datasources/remote/auth_remote_data_source.dart'
    as _i993;
import 'package:expense_tracker/features/auth/data/models/hive_user_model.dart'
    as _i385;
import 'package:expense_tracker/features/auth/di/auth_module.dart' as _i903;
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart'
    as _i664;
import 'package:expense_tracker/features/auth/domain/usecases/change_password_usecase.dart'
    as _i43;
import 'package:expense_tracker/features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i917;
import 'package:expense_tracker/features/auth/domain/usecases/check_remember_me_usecase.dart'
    as _i452;
import 'package:expense_tracker/features/auth/domain/usecases/clear_remember_me_usecase.dart'
    as _i24;
import 'package:expense_tracker/features/auth/domain/usecases/forgot_password_usecase.dart'
    as _i402;
import 'package:expense_tracker/features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i353;
import 'package:expense_tracker/features/auth/domain/usecases/get_token_usecase.dart'
    as _i954;
import 'package:expense_tracker/features/auth/domain/usecases/is_signed_in_usecase.dart'
    as _i652;
import 'package:expense_tracker/features/auth/domain/usecases/reset_password_usecase.dart'
    as _i962;
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_as_guest_usecase.dart'
    as _i180;
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart'
    as _i673;
import 'package:expense_tracker/features/auth/domain/usecases/sign_out_usecase.dart'
    as _i894;
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart'
    as _i569;
import 'package:expense_tracker/features/auth/domain/usecases/update_user_usecase.dart'
    as _i1023;
import 'package:expense_tracker/features/auth/domain/usecases/validate_token_on_start_usecase.dart'
    as _i813;
import 'package:expense_tracker/features/auth/domain/usecases/validate_token_usecase.dart'
    as _i493;
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart'
    as _i985;
import 'package:expense_tracker/features/budget/data/local/budget_local_data_source.dart'
    as _i296;
import 'package:expense_tracker/features/budget/data/mappers/budget_mapper.dart'
    as _i963;
import 'package:expense_tracker/features/budget/di/budget_module.dart' as _i755;
import 'package:expense_tracker/features/budget/domain/repositories/budget_repository.dart'
    as _i96;
import 'package:expense_tracker/features/budget/domain/usecases/add_budget.dart'
    as _i281;
import 'package:expense_tracker/features/budget/domain/usecases/delete_budget.dart'
    as _i541;
import 'package:expense_tracker/features/budget/domain/usecases/get_budget.dart'
    as _i330;
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets.dart'
    as _i464;
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets_by_category.dart'
    as _i739;
import 'package:expense_tracker/features/budget/domain/usecases/get_budgets_by_date_range.dart'
    as _i375;
import 'package:expense_tracker/features/budget/domain/usecases/update_budget.dart'
    as _i1053;
import 'package:expense_tracker/features/category/data/local/category_local_data_source.dart'
    as _i786;
import 'package:expense_tracker/features/category/data/mappers/category_mapper.dart'
    as _i557;
import 'package:expense_tracker/features/category/data/remote/category_remote_data_source.dart'
    as _i420;
import 'package:expense_tracker/features/category/di/category_module.dart'
    as _i404;
import 'package:expense_tracker/features/category/domain/repositories/category_repository.dart'
    as _i139;
import 'package:expense_tracker/features/category/domain/usecases/add_category.dart'
    as _i656;
import 'package:expense_tracker/features/category/domain/usecases/delete_category.dart'
    as _i1060;
import 'package:expense_tracker/features/category/domain/usecases/get_categories.dart'
    as _i475;
import 'package:expense_tracker/features/category/domain/usecases/get_categories_by_type.dart'
    as _i667;
import 'package:expense_tracker/features/category/domain/usecases/get_category.dart'
    as _i948;
import 'package:expense_tracker/features/category/domain/usecases/update_category.dart'
    as _i439;
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart'
    as _i180;
import 'package:expense_tracker/features/expense/data/local/expense_local_data_source.dart'
    as _i231;
import 'package:expense_tracker/features/expense/data/mappers/expense_mapper.dart'
    as _i697;
import 'package:expense_tracker/features/expense/di/expense_module.dart'
    as _i902;
import 'package:expense_tracker/features/expense/domain/repositories/expense_repository.dart'
    as _i160;
import 'package:expense_tracker/features/expense/domain/usecases/add_expense.dart'
    as _i27;
import 'package:expense_tracker/features/expense/domain/usecases/delete_expense.dart'
    as _i782;
import 'package:expense_tracker/features/expense/domain/usecases/get_expense.dart'
    as _i918;
import 'package:expense_tracker/features/expense/domain/usecases/get_expenses.dart'
    as _i717;
import 'package:expense_tracker/features/expense/domain/usecases/get_expenses_by_category.dart'
    as _i779;
import 'package:expense_tracker/features/expense/domain/usecases/get_expenses_by_date_range.dart'
    as _i593;
import 'package:expense_tracker/features/expense/domain/usecases/get_total_expenses_by_category.dart'
    as _i415;
import 'package:expense_tracker/features/expense/domain/usecases/update_expense.dart'
    as _i407;
import 'package:expense_tracker/features/transaction/data/local/transaction_local_data_source.dart'
    as _i525;
import 'package:expense_tracker/features/transaction/data/mappers/transaction_mapper.dart'
    as _i668;
import 'package:expense_tracker/features/transaction/data/remote/transaction_remote_data_source.dart'
    as _i709;
import 'package:expense_tracker/features/transaction/di/transaction_module.dart'
    as _i356;
import 'package:expense_tracker/features/transaction/domain/repositories/transaction_repository.dart'
    as _i89;
import 'package:expense_tracker/features/transaction/domain/usecases/add_transaction.dart'
    as _i882;
import 'package:expense_tracker/features/transaction/domain/usecases/delete_transaction.dart'
    as _i675;
import 'package:expense_tracker/features/transaction/domain/usecases/get_total_transactions_by_category.dart'
    as _i969;
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart'
    as _i756;
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions_by_category.dart'
    as _i481;
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions_by_date_range.dart'
    as _i178;
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions_by_type.dart'
    as _i312;
import 'package:expense_tracker/features/transaction/domain/usecases/update_transaction.dart'
    as _i251;
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_bloc.dart'
    as _i814;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
    final coreModule = _$CoreModule();
    final categoryModule = _$CategoryModule();
    final expenseModule = _$ExpenseModule();
    final budgetModule = _$BudgetModule();
    final transactionModule = _$TransactionModule();
    final authModule = _$AuthModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => coreModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i557.CategoryMapper>(() => categoryModule.categoryMapper());
    gh.singleton<_i786.CategoryLocalDataSource>(
        () => categoryModule.categoryLocalDataSource());
    gh.singleton<_i697.ExpenseMapper>(() => expenseModule.expenseMapper);
    gh.singleton<_i231.ExpenseLocalDataSource>(
        () => expenseModule.expenseLocalDataSource);
    gh.singleton<_i160.ExpenseRepository>(
        () => expenseModule.expenseRepository);
    gh.singleton<_i27.AddExpense>(() => expenseModule.addExpense);
    gh.singleton<_i717.GetExpenses>(() => expenseModule.getExpenses);
    gh.singleton<_i918.GetExpense>(() => expenseModule.getExpense);
    gh.singleton<_i779.GetExpensesByCategory>(
        () => expenseModule.getExpensesByCategory);
    gh.singleton<_i415.GetTotalExpensesByCategory>(
        () => expenseModule.getTotalExpensesByCategory);
    gh.singleton<_i593.GetExpensesByDateRange>(
        () => expenseModule.getExpensesByDateRange);
    gh.singleton<_i407.UpdateExpense>(() => expenseModule.updateExpense);
    gh.singleton<_i782.DeleteExpense>(() => expenseModule.deleteExpense);
    gh.singleton<_i963.BudgetMapper>(() => budgetModule.budgetMapper);
    gh.singleton<_i296.BudgetLocalDataSource>(
        () => budgetModule.budgetLocalDataSource);
    gh.singleton<_i96.BudgetRepository>(() => budgetModule.budgetRepository);
    gh.singleton<_i281.AddBudget>(() => budgetModule.addBudget);
    gh.singleton<_i464.GetBudgets>(() => budgetModule.getBudgets);
    gh.singleton<_i330.GetBudget>(() => budgetModule.getBudget);
    gh.singleton<_i1053.UpdateBudget>(() => budgetModule.updateBudget);
    gh.singleton<_i541.DeleteBudget>(() => budgetModule.deleteBudget);
    gh.singleton<_i739.GetBudgetsByCategory>(
        () => budgetModule.getBudgetsByCategory);
    gh.singleton<_i375.GetBudgetsByDateRange>(
        () => budgetModule.getBudgetsByDateRange);
    gh.singleton<_i668.TransactionMapper>(
        () => transactionModule.transactionMapper());
    gh.singleton<_i525.TransactionLocalDataSource>(
        () => transactionModule.transactionLocalDataSource());
    gh.singleton<_i361.Dio>(() => coreModule.dio);
    gh.singleton<_i973.InternetConnectionChecker>(
        () => coreModule.connectionChecker());
    gh.singleton<_i225.ThemeService>(
        () => coreModule.themeService(gh<_i460.SharedPreferences>()));
    gh.singleton<_i986.ThemeBloc>(
        () => coreModule.themeBloc(gh<_i225.ThemeService>()));
    await gh.factoryAsync<_i986.Box<_i385.HiveUserModel>>(
      () => coreModule.userBox(),
      instanceName: 'users',
      preResolve: true,
    );
    gh.singleton<_i721.NetworkInfo>(
        () => coreModule.networkInfo(gh<_i973.InternetConnectionChecker>()));
    await gh.factoryAsync<_i986.Box<String>>(
      () => coreModule.tokenBox(),
      instanceName: 'tokens',
      preResolve: true,
    );
    await gh.factoryAsync<_i986.Box<bool>>(
      () => coreModule.preferencesBox(),
      instanceName: 'preferences',
      preResolve: true,
    );
    gh.singleton<_i615.AuthLocalDataSource>(
        () => authModule.authLocalDataSource(
              gh<_i986.Box<_i385.HiveUserModel>>(instanceName: 'users'),
              gh<_i986.Box<String>>(instanceName: 'tokens'),
              gh<_i986.Box<bool>>(instanceName: 'preferences'),
            ));
    await gh.singletonAsync<_i102.ApiService>(
      () => coreModule.apiService(
        gh<_i361.Dio>(),
        gh<_i986.Box<String>>(instanceName: 'tokens'),
      ),
      preResolve: true,
    );
    gh.singleton<_i420.CategoryRemoteDataSource>(
        () => categoryModule.categoryRemoteDataSource(
              gh<_i102.ApiService>(),
              gh<_i557.CategoryMapper>(),
            ));
    gh.singleton<_i709.TransactionRemoteDataSource>(
        () => transactionModule.transactionRemoteDataSource(
              gh<_i102.ApiService>(),
              gh<_i668.TransactionMapper>(),
            ));
    gh.singleton<_i89.TransactionRepository>(
        () => transactionModule.transactionRepository(
              gh<_i525.TransactionLocalDataSource>(),
              gh<_i709.TransactionRemoteDataSource>(),
              gh<_i668.TransactionMapper>(),
              gh<_i721.NetworkInfo>(),
            ));
    gh.singleton<_i993.AuthRemoteDataSource>(
        () => authModule.authRemoteDataSource(gh<_i102.ApiService>()));
    gh.singleton<_i664.AuthRepository>(() => authModule.authRepository(
          gh<_i993.AuthRemoteDataSource>(),
          gh<_i615.AuthLocalDataSource>(),
          gh<_i721.NetworkInfo>(),
          gh<_i102.ApiService>(),
        ));
    gh.singleton<_i139.CategoryRepository>(
        () => categoryModule.categoryRepository(
              gh<_i786.CategoryLocalDataSource>(),
              gh<_i420.CategoryRemoteDataSource>(),
              gh<_i557.CategoryMapper>(),
              gh<_i721.NetworkInfo>(),
            ));
    gh.lazySingleton<_i673.SignInUseCase>(
        () => authModule.signInUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i569.SignUpUseCase>(
        () => authModule.signUpUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i402.ForgotPasswordUseCase>(
        () => authModule.forgotPasswordUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i962.ResetPasswordUseCase>(
        () => authModule.resetPasswordUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i894.SignOutUseCase>(
        () => authModule.signOutUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i180.SignInAsGuestUseCase>(
        () => authModule.signInAsGuestUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i954.GetTokenUseCase>(
        () => authModule.getTokenUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i353.GetCurrentUserUseCase>(
        () => authModule.getCurrentUserUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i1023.UpdateUserUseCase>(
        () => authModule.updateUserUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i43.ChangePasswordUseCase>(
        () => authModule.changePasswordUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i652.IsSignedInUseCase>(
        () => authModule.isSignedInUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i493.ValidateTokenUseCase>(
        () => authModule.validateTokenUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i452.CheckRememberMeUseCase>(
        () => authModule.checkRememberMeUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i813.ValidateTokenOnStartUseCase>(() =>
        authModule.validateTokenOnStartUseCase(gh<_i664.AuthRepository>()));
    gh.lazySingleton<_i24.ClearRememberMeUseCase>(
        () => authModule.clearRememberMeUseCase(gh<_i664.AuthRepository>()));
    gh.singleton<_i656.AddCategory>(() =>
        categoryModule.addCategoryUseCase(gh<_i139.CategoryRepository>()));
    gh.singleton<_i475.GetCategories>(
        () => categoryModule.getCategories(gh<_i139.CategoryRepository>()));
    gh.singleton<_i948.GetCategory>(
        () => categoryModule.getCategory(gh<_i139.CategoryRepository>()));
    gh.singleton<_i439.UpdateCategory>(
        () => categoryModule.updateCategory(gh<_i139.CategoryRepository>()));
    gh.singleton<_i1060.DeleteCategory>(
        () => categoryModule.deleteCategory(gh<_i139.CategoryRepository>()));
    gh.singleton<_i667.GetCategoriesByType>(() =>
        categoryModule.getCategoriesByType(gh<_i139.CategoryRepository>()));
    gh.factory<_i180.CategoryBloc>(() => categoryModule.categoryBloc(
          gh<_i475.GetCategories>(),
          gh<_i948.GetCategory>(),
          gh<_i656.AddCategory>(),
          gh<_i439.UpdateCategory>(),
          gh<_i1060.DeleteCategory>(),
          gh<_i667.GetCategoriesByType>(),
          gh<_i139.CategoryRepository>(),
        ));
    gh.singleton<_i882.AddTransaction>(() =>
        transactionModule.addTransaction(gh<_i89.TransactionRepository>()));
    gh.singleton<_i756.GetTransactions>(() =>
        transactionModule.getTransactions(gh<_i89.TransactionRepository>()));
    gh.singleton<_i312.GetTransactionsByType>(() => transactionModule
        .getTransactionsByType(gh<_i89.TransactionRepository>()));
    gh.singleton<_i251.UpdateTransaction>(() =>
        transactionModule.updateTransaction(gh<_i89.TransactionRepository>()));
    gh.singleton<_i675.DeleteTransaction>(() =>
        transactionModule.deleteTransaction(gh<_i89.TransactionRepository>()));
    gh.singleton<_i178.GetTransactionsByDateRange>(() => transactionModule
        .getTransactionsByDateRange(gh<_i89.TransactionRepository>()));
    gh.singleton<_i481.GetTransactionsByCategory>(() => transactionModule
        .getTransactionsByCategory(gh<_i89.TransactionRepository>()));
    gh.singleton<_i969.GetTotalTransactionsByCategory>(() => transactionModule
        .getTotalTransactionsByCategory(gh<_i89.TransactionRepository>()));
    gh.lazySingleton<_i917.CheckAuthStatusUseCase>(
        () => authModule.checkAuthStatusUseCase(
              gh<_i664.AuthRepository>(),
              gh<_i452.CheckRememberMeUseCase>(),
              gh<_i813.ValidateTokenOnStartUseCase>(),
            ));
    gh.factory<_i985.AuthBloc>(() => authModule.authBloc(
          gh<_i673.SignInUseCase>(),
          gh<_i569.SignUpUseCase>(),
          gh<_i402.ForgotPasswordUseCase>(),
          gh<_i962.ResetPasswordUseCase>(),
          gh<_i894.SignOutUseCase>(),
          gh<_i180.SignInAsGuestUseCase>(),
          gh<_i954.GetTokenUseCase>(),
          gh<_i353.GetCurrentUserUseCase>(),
          gh<_i1023.UpdateUserUseCase>(),
          gh<_i43.ChangePasswordUseCase>(),
          gh<_i652.IsSignedInUseCase>(),
          gh<_i493.ValidateTokenUseCase>(),
          gh<_i917.CheckAuthStatusUseCase>(),
          gh<_i24.ClearRememberMeUseCase>(),
        ));
    gh.singleton<_i814.TransactionBloc>(() => transactionModule.transactionBloc(
          gh<_i756.GetTransactions>(),
          gh<_i882.AddTransaction>(),
          gh<_i251.UpdateTransaction>(),
          gh<_i675.DeleteTransaction>(),
        ));
    gh.factory<_i43.AuthInterceptor>(
        () => _i43.AuthInterceptor(gh<_i985.AuthBloc>()));
    return this;
  }
}

class _$CoreModule extends _i370.CoreModule {}

class _$CategoryModule extends _i404.CategoryModule {}

class _$ExpenseModule extends _i902.ExpenseModule {}

class _$BudgetModule extends _i755.BudgetModule {}

class _$TransactionModule extends _i356.TransactionModule {}

class _$AuthModule extends _i903.AuthModule {}
