import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/sign_in_as_guest_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/validate_token_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/clear_remember_me_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final SignOutUseCase _signOutUseCase;
  final SignInAsGuestUseCase _signInAsGuestUseCase;
  final GetTokenUseCase _getTokenUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final ValidateTokenUseCase _validateTokenUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final ClearRememberMeUseCase _clearRememberMeUseCase;
  final AppLocalizations _l10n;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required SignOutUseCase signOutUseCase,
    required SignInAsGuestUseCase signInAsGuestUseCase,
    required GetTokenUseCase getTokenUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required ValidateTokenUseCase validateTokenUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required ClearRememberMeUseCase clearRememberMeUseCase,
    required AppLocalizations l10n,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _signOutUseCase = signOutUseCase,
        _signInAsGuestUseCase = signInAsGuestUseCase,
        _getTokenUseCase = getTokenUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        _validateTokenUseCase = validateTokenUseCase,
        _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _clearRememberMeUseCase = clearRememberMeUseCase,
        _l10n = l10n,
        super(const AuthInitial()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<SignInAsGuestEvent>(_onSignInAsGuest);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<UpdateCurrencyEvent>(_onUpdateCurrency);
    on<ChangePasswordEvent>(_onChangePassword);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final result = await _signInUseCase(
        SignInParams(
          email: event.email,
          password: event.password,
          rememberMe: event.rememberMe,
        ),
      );
      await result.fold(
        (failure) async => emit(AuthError(message: _getErrorMessage(failure))),
        (user) async {
          if (event.rememberMe) {
            final tokenResult = await _getTokenUseCase(NoParams());
            await tokenResult.fold(
              (failure) async =>
                  emit(AuthError(message: _getErrorMessage(failure))),
              (token) async {
                if (token != null) {
                  final validateResult = await _validateTokenUseCase(
                      ValidateTokenParams(token: token));
                  await validateResult.fold(
                    (failure) async =>
                        emit(AuthError(message: _getErrorMessage(failure))),
                    (isValid) async {
                      if (isValid) {
                        emit(AuthAuthenticated(user: user, token: token));
                      } else {
                        // Token is invalid, clear it and sign out
                        await _signOutUseCase(NoParams());
                        emit(const AuthUnauthenticated());
                      }
                    },
                  );
                } else {
                  emit(AuthAuthenticated(user: user));
                }
              },
            );
          } else {
            emit(AuthAuthenticated(user: user));
          }
        },
      );
    } catch (e) {
      emit(AuthError(message: _l10n.get('unexpected_error')));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading());
      final result = await _signUpUseCase(
        SignUpParams(
          email: event.email,
          password: event.password,
          firstName: event.firstName,
          lastName: event.lastName,
        ),
      );

      await result.fold(
        (failure) async => emit(AuthError(message: _getErrorMessage(failure))),
        (user) async {
          final tokenResult = await _getTokenUseCase(NoParams());
          await tokenResult.fold(
            (failure) async =>
                emit(AuthError(message: _getErrorMessage(failure))),
            (token) async {
              if (token != null) {
                emit(AuthAuthenticated(user: user, token: token));
              } else {
                emit(const AuthUnauthenticated());
              }
            },
          );
        },
      );
    } catch (e) {
      emit(AuthError(message: _l10n.get('unexpected_error')));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _signOutUseCase(NoParams());
    await result.fold(
      (failure) async => emit(state.copyWith(
        isLoading: false,
        error: _getErrorMessage(failure),
      )),
      (_) async {
        // Clear remember me preference when signing out
        await _clearRememberMeUseCase(NoParams());
        emit(const AuthUnauthenticated());
      },
    );
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );
    result.fold(
      (failure) => emit(AuthError(message: _getErrorMessage(failure))),
      (message) => emit(AuthSuccess(message: message)),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _resetPasswordUseCase(
      ResetPasswordParams(
        token: event.token,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(message: _getErrorMessage(failure))),
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> _onSignInAsGuest(
    SignInAsGuestEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signInAsGuestUseCase(NoParams());

    await result.fold(
      (failure) async => emit(AuthError(message: _getErrorMessage(failure))),
      (user) async {
        final tokenResult = await _getTokenUseCase(NoParams());
        await tokenResult.fold(
          (failure) async =>
              emit(AuthError(message: _getErrorMessage(failure))),
          (token) async {
            if (token != null) {
              emit(AuthAuthenticated(user: user, token: token));
            } else {
              emit(const AuthUnauthenticated());
            }
          },
        );
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _checkAuthStatusUseCase(NoParams());
    await result.fold(
      (failure) async => emit(state.copyWith(
        isLoading: false,
        error: _getErrorMessage(failure),
      )),
      (isAuthenticated) async {
        if (isAuthenticated) {
          emit(state.copyWith(isLoading: true, error: null));
          final userResult = await _getCurrentUserUseCase(NoParams());
          final tokenResult = await _getTokenUseCase(NoParams());

          if (userResult.isRight() && tokenResult.isRight()) {
            final user =
                userResult.getOrElse(() => throw Exception('User not found'));
            final token = tokenResult.getOrElse(() => null);
            emit(AuthAuthenticated(user: user, token: token));
          } else {
            emit(state.copyWith(
              isLoading: false,
              error: _l10n.get('user_data_not_found'),
            ));
          }
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onUpdateCurrency(
    UpdateCurrencyEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentUser = (state as AuthAuthenticated).user;
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(currency: event.currency);

        final result =
            await _updateUserUseCase(UpdateUserParams(user: updatedUser));
        await result.fold(
          (failure) async =>
              emit(AuthError(message: _getErrorMessage(failure))),
          (user) async =>
              emit(AuthAuthenticated(user: user, token: state.token)),
        );
      }
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      emit(currentState.copyWith(isLoading: true, error: null));
      try {
        final result = await _changePasswordUseCase(
          ChangePasswordParams(
            currentPassword: event.currentPassword,
            newPassword: event.newPassword,
          ),
        );
        await result.fold(
          (failure) async {
            if (failure is ServerFailure) {
              emit(currentState.copyWith(
                isLoading: false,
                error: failure.message,
              ));
            } else {
              emit(currentState.copyWith(
                isLoading: false,
                error: _getErrorMessage(failure),
              ));
            }
          },
          (_) async {
            emit(currentState.copyWith(
              isLoading: false,
              successMessage: _l10n.get('password_changed'),
            ));
          },
        );
      } catch (e) {
        emit(currentState.copyWith(
          isLoading: false,
          error: _l10n.get('unexpected_error'),
        ));
      }
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      if (currentState.user == null) {
        emit(currentState.copyWith(
          isLoading: false,
          error: _l10n.get('user_data_not_found'),
        ));
        return;
      }

      emit(currentState.copyWith(isLoading: true, error: null));
      try {
        final updatedUser = currentState.user!.copyWith(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
        );

        final result = await _updateUserUseCase(
          UpdateUserParams(
            user: updatedUser,
            profilePicture: event.profilePicture,
          ),
        );

        await result.fold(
          (failure) async {
            if (failure is ServerFailure) {
              emit(currentState.copyWith(
                isLoading: false,
                error: failure.message,
              ));
            } else {
              emit(currentState.copyWith(
                isLoading: false,
                error: _getErrorMessage(failure),
              ));
            }
          },
          (user) async {
            emit(currentState.copyWith(
              isLoading: false,
              successMessage: _l10n.get('profile_updated'),
              user: user,
            ));
          },
        );
      } catch (e) {
        emit(currentState.copyWith(
          isLoading: false,
          error: _l10n.get('unexpected_error'),
        ));
      }
    }
  }

  void _onUpdateLanguage(
      UpdateLanguageEvent event, Emitter<AuthState> emit) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      try {
        emit(currentState.copyWith(isLoading: true));

        if (currentState.user == null) {
          emit(currentState.copyWith(
            isLoading: false,
            error: _l10n.get('user_data_not_found'),
          ));
          return;
        }

        final updatedUser =
            currentState.user!.copyWith(language: event.language);
        final result =
            await _updateUserUseCase(UpdateUserParams(user: updatedUser));

        result.fold(
          (failure) => emit(currentState.copyWith(
            isLoading: false,
            error: _getErrorMessage(failure),
          )),
          (user) => emit(AuthAuthenticated(
            user: user,
            isLoading: false,
          )),
        );
      } catch (e) {
        emit(currentState.copyWith(
          isLoading: false,
          error: _l10n.get('unexpected_error'),
        ));
      }
    }
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case CacheFailure:
        return failure.message;
      default:
        return _l10n.get('unexpected_error');
    }
  }
}
