import 'package:expense_tracker/features/auth/domain/services/biometric_service.dart';
import 'package:expense_tracker/features/auth/domain/usecases/resend_verification_code_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/verify_otp_usecase.dart';
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
import 'package:flutter/foundation.dart';

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
  final BiometricService _biometricService;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendVerificationCodeUseCase _resendVerificationCodeUseCase;

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
    required BiometricService biometricService,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResendVerificationCodeUseCase resendVerificationCodeUseCase,
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
        _biometricService = biometricService,
        _verifyOtpUseCase = verifyOtpUseCase,
        _resendVerificationCodeUseCase = resendVerificationCodeUseCase,
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
    on<AuthenticateWithBiometricsEvent>(_onAuthenticateWithBiometrics);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendVerificationCodeEvent>(_onResendVerificationCode);

    // Check auth status on initialization
    add(const CheckAuthStatusEvent());
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
        (failure) async {
          // Check if the error is about user already existing
          if (failure is AuthFailure &&
              failure.message.toLowerCase().contains('already exists')) {
            // Try to resend verification code
            final resendResult = await _resendVerificationCodeUseCase(
              ResendVerificationCodeParams(email: event.email),
            );

            await resendResult.fold(
              (resendFailure) async =>
                  emit(AuthError(message: _getErrorMessage(resendFailure))),
              (_) async => emit(ResendCodeSuccess()),
            );
          } else {
            emit(AuthError(message: _getErrorMessage(failure)));
          }
        },
        (user) async {
          emit(AuthSuccess(
            message: _l10n.get('sign_up_success_message'),
            user: user,
          ));
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
    try {
      debugPrint('Starting guest sign-in process');
      emit(const AuthLoading());
      final result = await _signInAsGuestUseCase(NoParams());

      await result.fold(
        (failure) async {
          debugPrint('Guest sign-in failed: ${failure.message}');
          emit(AuthError(message: _getErrorMessage(failure)));
        },
        (user) async {
          debugPrint('Guest sign-in successful: ${user.email}');
          emit(AuthAuthenticated(
            user: user.copyWith(isGuest: true),
            token: null,
          ));
        },
      );
    } catch (e) {
      debugPrint('Guest sign-in error: $e');
      emit(AuthError(message: _l10n.get('unexpected_error')));
    }
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

            // Check if user has enabled biometric authentication
            final shouldUseBiometrics =
                await _biometricService.shouldUseBiometrics();

            if (shouldUseBiometrics) {
              // Emit a state that indicates biometric auth is required
              emit(AuthBiometricRequired(user: user, token: token));
            } else {
              // Proceed with normal authentication
              emit(AuthAuthenticated(user: user, token: token));
            }
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
      final currentState = state as AuthAuthenticated;
      final currentUser = currentState.user;
      if (currentUser != null) {
        emit(currentState.copyWith(isLoading: true, error: null));
        try {
          final updatedUser = currentUser.copyWith(currency: event.currency);

          final result =
              await _updateUserUseCase(UpdateUserParams(user: updatedUser));
          await result.fold(
            (failure) async {
              if (failure is ServerFailure) {
                // Extract the error message from the server response
                final errorMessage = failure.message;
                if (errorMessage.contains('supportedCurrencies')) {
                  // Parse the supported currencies from the error message
                  final supportedCurrencies = errorMessage
                      .split('supportedCurrencies":[')[1]
                      .split(']')[0]
                      .replaceAll('"', '')
                      .split(',');
                  emit(currentState.copyWith(
                    isLoading: false,
                    error:
                        'Invalid currency. Supported currencies: ${supportedCurrencies.join(', ')}',
                  ));
                } else {
                  emit(currentState.copyWith(
                    isLoading: false,
                    error: errorMessage,
                  ));
                }
              } else {
                emit(currentState.copyWith(
                  isLoading: false,
                  error: _getErrorMessage(failure),
                ));
              }
            },
            (user) async => emit(AuthAuthenticated(
              user: user,
              token: currentState.token,
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

  Future<void> _onAuthenticateWithBiometrics(
    AuthenticateWithBiometricsEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Validate the token if provided
      if (event.token != null) {
        final validateResult = await _validateTokenUseCase(
          ValidateTokenParams(token: event.token!),
        );
        await validateResult.fold(
          (failure) async =>
              emit(AuthError(message: _getErrorMessage(failure))),
          (isValid) async {
            if (isValid) {
              emit(AuthAuthenticated(user: event.user, token: event.token));
            } else {
              // Token is invalid, clear it and sign out
              await _signOutUseCase(NoParams());
              emit(const AuthUnauthenticated());
            }
          },
        );
      } else {
        // If no token, just emit authenticated state
        emit(AuthAuthenticated(user: event.user));
      }
    } catch (e) {
      emit(AuthError(message: _l10n.get('unexpected_error')));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpVerificationLoading());
    final result = await _verifyOtpUseCase(
        VerifyOtpParams(otp: event.otp, email: event.email));
    result.fold(
      (failure) => emit(OtpVerificationFailure(failure.message)),
      (_) => emit(OtpVerificationSuccess()),
    );
  }

  Future<void> _onResendVerificationCode(
    ResendVerificationCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      final result = await _resendVerificationCodeUseCase(
        ResendVerificationCodeParams(email: event.email),
      );

      await result.fold(
        (failure) async => emit(AuthError(message: _getErrorMessage(failure))),
        (_) async => emit(ResendCodeSuccess()),
      );
    } catch (e) {
      emit(AuthError(message: _l10n.get('unexpected_error')));
    }
  }

  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is AuthFailure) {
      return failure.message;
    } else {
      return _l10n.get('unexpected_error');
    }
  }
}
