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

@module
abstract class AuthModule {
  @singleton
  AuthLocalDataSource authLocalDataSource(
    @Named('users') Box<HiveUserModel> userBox,
    @Named('tokens') Box<String> tokenBox,
  ) =>
      AuthLocalDataSourceImpl(
        userBox: userBox,
        tokenBox: tokenBox,
      );

  @singleton
  AuthRemoteDataSource authRemoteDataSource(ApiService apiService) =>
      AuthRemoteDataSourceImpl(apiService);

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

  @singleton
  SignInUseCase signInUseCase(AuthRepository repository) =>
      SignInUseCase(repository);

  @singleton
  SignUpUseCase signUpUseCase(AuthRepository repository) =>
      SignUpUseCase(repository);

  @singleton
  SignOutUseCase signOutUseCase(AuthRepository repository) =>
      SignOutUseCase(repository);

  @singleton
  ChangePasswordUseCase changePasswordUseCase(AuthRepository repository) =>
      ChangePasswordUseCase(repository);

  @singleton
  UpdateUserUseCase updateUserUseCase(AuthRepository repository) =>
      UpdateUserUseCase(repository);

  @singleton
  ResetPasswordUseCase resetPasswordUseCase(AuthRepository repository) =>
      ResetPasswordUseCase(repository);

  @singleton
  ForgotPasswordUseCase forgotPasswordUseCase(AuthRepository repository) =>
      ForgotPasswordUseCase(repository);

  @singleton
  GetCurrentUserUseCase getCurrentUserUseCase(AuthRepository repository) =>
      GetCurrentUserUseCase(repository);

  @singleton
  IsSignedInUseCase isSignedInUseCase(AuthRepository repository) =>
      IsSignedInUseCase(repository);

  @singleton
  GetTokenUseCase getTokenUseCase(AuthRepository repository) =>
      GetTokenUseCase(repository);

  @singleton
  ValidateTokenUseCase validateTokenUseCase(AuthRepository repository) =>
      ValidateTokenUseCase(repository);
}
