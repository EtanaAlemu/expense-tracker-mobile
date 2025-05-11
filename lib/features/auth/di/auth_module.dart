import 'package:expense_tracker/features/auth/domain/usecases/validate_token_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:expense_tracker/features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:expense_tracker/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:expense_tracker/features/auth/data/datasources/remote/auth_remote_data_source_impl.dart';
import 'package:expense_tracker/features/auth/data/models/hive_user_model.dart';
import 'package:expense_tracker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/is_signed_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_as_guest_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/domain/usecases/check_remember_me_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/validate_token_on_start_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/clear_remember_me_usecase.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

@module
abstract class AuthModule {
  @singleton
  AuthLocalDataSource authLocalDataSource(
    @Named('users') Box<HiveUserModel> userBox,
    @Named('tokens') Box<String> tokenBox,
    @Named('preferences') Box<bool> preferencesBox,
  ) =>
      AuthLocalDataSourceImpl(
        userBox: userBox,
        tokenBox: tokenBox,
        preferencesBox: preferencesBox,
      );

  @singleton
  AuthRemoteDataSource authRemoteDataSource(
    ApiService apiService,
    AppLocalizations l10n,
  ) =>
      AuthRemoteDataSourceImpl(apiService, l10n);

  @singleton
  AuthRepository authRepository(
    AuthRemoteDataSource remoteDataSource,
    AuthLocalDataSource localDataSource,
    NetworkInfo networkInfo,
    ApiService apiService,
  ) =>
      AuthRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo,
        apiService: apiService,
      );

  @lazySingleton
  SignInUseCase signInUseCase(AuthRepository repository) =>
      SignInUseCase(repository);

  @lazySingleton
  SignUpUseCase signUpUseCase(AuthRepository repository) =>
      SignUpUseCase(repository);

  @lazySingleton
  ForgotPasswordUseCase forgotPasswordUseCase(AuthRepository repository) =>
      ForgotPasswordUseCase(repository);

  @lazySingleton
  ResetPasswordUseCase resetPasswordUseCase(AuthRepository repository) =>
      ResetPasswordUseCase(repository);

  @lazySingleton
  SignOutUseCase signOutUseCase(AuthRepository repository) =>
      SignOutUseCase(repository);

  @lazySingleton
  SignInAsGuestUseCase signInAsGuestUseCase(AuthRepository repository) =>
      SignInAsGuestUseCase(repository);

  @lazySingleton
  GetTokenUseCase getTokenUseCase(AuthRepository repository) =>
      GetTokenUseCase(repository);

  @lazySingleton
  GetCurrentUserUseCase getCurrentUserUseCase(AuthRepository repository) =>
      GetCurrentUserUseCase(repository);

  @lazySingleton
  UpdateUserUseCase updateUserUseCase(AuthRepository repository) =>
      UpdateUserUseCase(repository);

  @lazySingleton
  ChangePasswordUseCase changePasswordUseCase(AuthRepository repository) =>
      ChangePasswordUseCase(repository);

  @lazySingleton
  IsSignedInUseCase isSignedInUseCase(AuthRepository repository) =>
      IsSignedInUseCase(repository);

  @lazySingleton
  ValidateTokenUseCase validateTokenUseCase(AuthRepository repository) =>
      ValidateTokenUseCase(repository);

  @lazySingleton
  CheckRememberMeUseCase checkRememberMeUseCase(AuthRepository repository) =>
      CheckRememberMeUseCase(repository);

  @lazySingleton
  ValidateTokenOnStartUseCase validateTokenOnStartUseCase(
          AuthRepository repository) =>
      ValidateTokenOnStartUseCase(repository);

  @lazySingleton
  CheckAuthStatusUseCase checkAuthStatusUseCase(
    AuthRepository repository,
    CheckRememberMeUseCase checkRememberMeUseCase,
    ValidateTokenOnStartUseCase validateTokenOnStartUseCase,
  ) =>
      CheckAuthStatusUseCase(
        repository,
        checkRememberMeUseCase,
        validateTokenOnStartUseCase,
      );

  @lazySingleton
  ClearRememberMeUseCase clearRememberMeUseCase(AuthRepository repository) =>
      ClearRememberMeUseCase(repository);

  @injectable
  AuthBloc authBloc(
    SignInUseCase signInUseCase,
    SignUpUseCase signUpUseCase,
    ForgotPasswordUseCase forgotPasswordUseCase,
    ResetPasswordUseCase resetPasswordUseCase,
    SignOutUseCase signOutUseCase,
    SignInAsGuestUseCase signInAsGuestUseCase,
    GetTokenUseCase getTokenUseCase,
    GetCurrentUserUseCase getCurrentUserUseCase,
    UpdateUserUseCase updateUserUseCase,
    ChangePasswordUseCase changePasswordUseCase,
    ValidateTokenUseCase validateTokenUseCase,
    CheckAuthStatusUseCase checkAuthStatusUseCase,
    ClearRememberMeUseCase clearRememberMeUseCase,
    AppLocalizations l10n,
  ) =>
      AuthBloc(
        signInUseCase: signInUseCase,
        signUpUseCase: signUpUseCase,
        forgotPasswordUseCase: forgotPasswordUseCase,
        resetPasswordUseCase: resetPasswordUseCase,
        signOutUseCase: signOutUseCase,
        signInAsGuestUseCase: signInAsGuestUseCase,
        getTokenUseCase: getTokenUseCase,
        getCurrentUserUseCase: getCurrentUserUseCase,
        updateUserUseCase: updateUserUseCase,
        changePasswordUseCase: changePasswordUseCase,
        validateTokenUseCase: validateTokenUseCase,
        checkAuthStatusUseCase: checkAuthStatusUseCase,
        clearRememberMeUseCase: clearRememberMeUseCase,
        l10n: l10n,
      );
}
