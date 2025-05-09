import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/validate_token_usecase.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final SignUpUseCase _signUpUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final GetTokenUseCase _getTokenUseCase;
  final ValidateTokenUseCase _validateTokenUseCase;
  String? _token;
  User? _user;

  AuthBloc(
    this._signInUseCase,
    this._signOutUseCase,
    this._checkAuthStatusUseCase,
    this._signUpUseCase,
    this._updateUserUseCase,
    this._changePasswordUseCase,
    this._resetPasswordUseCase,
    this._forgotPasswordUseCase,
    this._getTokenUseCase,
    this._validateTokenUseCase,
  ) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        signIn: (e) => _onSignIn(e, emit),
        signOut: (e) => _onSignOut(e, emit),
        checkAuthStatus: (e) => _onCheckAuthStatus(e, emit),
        signUp: (e) => _onSignUp(e, emit),
        updateUser: (e) => _onUpdateUser(e, emit),
        changePassword: (e) => _onChangePassword(e, emit),
        resetPassword: (e) => _onResetPassword(e, emit),
        forgotPassword: (e) => _onForgotPassword(e, emit),
      );
    });
  }

  String? get token => _token;
  User? get user => _user;

  Future<void> _onSignIn(SignIn event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );
    await result.fold(
      (failure) async => emit(AuthState.error(failure.message)),
      (_) async {
        final userResult = await _checkAuthStatusUseCase();
        await userResult.fold(
          (failure) async => emit(AuthState.error(failure.message)),
          (user) async {
            _user = user;
            final tokenResult = await _getTokenUseCase(null);
            await tokenResult.fold(
              (failure) async => emit(AuthState.error(failure.message)),
              (token) async {
                _token = token;
                emit(AuthState.authenticated(user));
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) {
        _user = null;
        _token = null;
        emit(const AuthState.unauthenticated());
      },
    );
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    // First get the token
    final tokenResult = await _getTokenUseCase(null);
    await tokenResult.fold(
      (failure) async => emit(const AuthState.unauthenticated()),
      (token) async {
        if (token == null) {
          emit(const AuthState.unauthenticated());
          return;
        }

        // Validate the token
        final validationResult = await _validateTokenUseCase(token);
        await validationResult.fold(
          (failure) async => emit(const AuthState.unauthenticated()),
          (isValid) async {
            if (!isValid) {
              emit(const AuthState.unauthenticated());
              return;
            }

            // Get user data
            final result = await _checkAuthStatusUseCase();
            await result.fold(
              (failure) async => emit(const AuthState.unauthenticated()),
              (user) async {
                _user = user;
                _token = token;
                emit(AuthState.authenticated(user));
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signUpUseCase(
      SignUpParams(
        user: User(
          id: '',
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          password: event.password,
          currency: 'USD',
        ),
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _updateUserUseCase(
      UpdateUserParams(user: event.user),
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) {
        _user = event.user;
        emit(AuthState.userUpdated(event.user));
      },
    );
  }

  Future<void> _onChangePassword(
      ChangePassword event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.passwordChanged()),
    );
  }

  Future<void> _onResetPassword(
      ResetPassword event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _resetPasswordUseCase({
      'token': event.token,
      'newPassword': event.newPassword,
    });
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.passwordReset()),
    );
  }

  Future<void> _onForgotPassword(
      ForgotPassword event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _forgotPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }
}
