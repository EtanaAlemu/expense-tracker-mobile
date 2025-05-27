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
import 'package:expense_tracker/core/services/connectivity/connectivity_service.dart';

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
  final ConnectivityService _connectivityService;

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
    required ConnectivityService connectivityService,
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
        _connectivityService = connectivityService,
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

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    if (change.nextState is AuthAuthenticated) {
      print('🔄 Auth state changed to authenticated, triggering data sync...');
      _connectivityService.syncData();
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    debugPrint('🔐 Sign in started for email: ${event.email}');
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
        (failure) async {
          debugPrint('❌ Sign in failed: ${failure.message}');
          emit(AuthError(message: _getErrorMessage(failure)));
        },
        (user) async {
          debugPrint('✅ Sign in successful for user: ${user.email}');
          if (event.rememberMe) {
            final tokenResult = await _getTokenUseCase(NoParams());
            await tokenResult.fold(
              (failure) async {
                debugPrint('❌ Failed to get token: ${failure.message}');
                emit(AuthError(message: _getErrorMessage(failure)));
              },
              (token) async {
                if (token != null) {
                  debugPrint('🔑 Token received, validating...');
                  final validateResult = await _validateTokenUseCase(
                      ValidateTokenParams(token: token));
                  await validateResult.fold(
                    (failure) async {
                      debugPrint(
                          '❌ Token validation failed: ${failure.message}');
                      emit(AuthError(message: _getErrorMessage(failure)));
                    },
                    (isValid) async {
                      if (isValid) {
                        debugPrint('✅ Token validated successfully');
                        // Ensure user data is cached before emitting state
                        final currentUserResult =
                            await _getCurrentUserUseCase(NoParams());
                        await currentUserResult.fold(
                          (failure) async {
                            debugPrint(
                                '❌ Failed to get cached user: ${failure.message}');
                            emit(AuthError(message: _getErrorMessage(failure)));
                          },
                          (cachedUser) async {
                            debugPrint('✅ User data cached successfully');
                            emit(AuthAuthenticated(
                                user: cachedUser, token: token));
                          },
                        );
                      } else {
                        debugPrint('❌ Token invalid, signing out');
                        await _signOutUseCase(NoParams());
                        emit(const AuthUnauthenticated());
                      }
                    },
                  );
                } else {
                  debugPrint('⚠️ No token received, proceeding without token');
                  // Ensure user data is cached before emitting state
                  final currentUserResult =
                      await _getCurrentUserUseCase(NoParams());
                  await currentUserResult.fold(
                    (failure) async {
                      debugPrint(
                          '❌ Failed to get cached user: ${failure.message}');
                      emit(AuthError(message: _getErrorMessage(failure)));
                    },
                    (cachedUser) async {
                      debugPrint('✅ User data cached successfully');
                      emit(AuthAuthenticated(user: cachedUser));
                    },
                  );
                }
              },
            );
          } else {
            debugPrint('ℹ️ Remember me not enabled, proceeding without token');
            // Ensure user data is cached before emitting state
            final currentUserResult = await _getCurrentUserUseCase(NoParams());
            await currentUserResult.fold(
              (failure) async {
                debugPrint('❌ Failed to get cached user: ${failure.message}');
                emit(AuthError(message: _getErrorMessage(failure)));
              },
              (cachedUser) async {
                debugPrint('✅ User data cached successfully');
                emit(AuthAuthenticated(user: cachedUser));
              },
            );
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected error during sign in: $e');
      emit(AuthError(message: _l10n.get('unexpected_error')));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    debugPrint('📝 Sign up started for email: ${event.email}');
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
          debugPrint('❌ Sign up failed: ${failure.message}');
          if (failure is AuthFailure &&
              failure.message.toLowerCase().contains('already exists')) {
            debugPrint(
                'ℹ️ User already exists, attempting to resend verification code');
            final resendResult = await _resendVerificationCodeUseCase(
              ResendVerificationCodeParams(email: event.email),
            );

            await resendResult.fold(
              (resendFailure) async {
                debugPrint(
                    '❌ Failed to resend verification code: ${resendFailure.message}');
                emit(AuthError(message: _getErrorMessage(resendFailure)));
              },
              (_) async {
                debugPrint('✅ Verification code resent successfully');
                emit(ResendCodeSuccess());
              },
            );
          } else {
            emit(AuthError(message: _getErrorMessage(failure)));
          }
        },
        (user) async {
          debugPrint('✅ Sign up successful for user: ${user.email}');
          emit(AuthSuccess(
            message: _l10n.get('sign_up_success_message'),
            user: user,
          ));
        },
      );
    } catch (e) {
      debugPrint('❌ Unexpected error during sign up: $e');
      emit(AuthError(message: _l10n.get('unexpected_error')));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    debugPrint('🚪 Sign out started');
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _signOutUseCase(NoParams());
    await result.fold(
      (failure) async {
        debugPrint('❌ Sign out failed: ${failure.message}');
        emit(state.copyWith(
          isLoading: false,
          error: _getErrorMessage(failure),
        ));
      },
      (_) async {
        debugPrint('✅ Sign out successful');
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
    debugPrint('🔍 Checking auth status');
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _checkAuthStatusUseCase(NoParams());
    await result.fold(
      (failure) async {
        debugPrint('❌ Auth status check failed: ${failure.message}');
        emit(state.copyWith(
          isLoading: false,
          error: _getErrorMessage(failure),
        ));
      },
      (isAuthenticated) async {
        if (isAuthenticated) {
          debugPrint('✅ User is authenticated, fetching user data');
          emit(state.copyWith(isLoading: true, error: null));
          final userResult = await _getCurrentUserUseCase(NoParams());
          final tokenResult = await _getTokenUseCase(NoParams());

          if (userResult.isRight() && tokenResult.isRight()) {
            final user =
                userResult.getOrElse(() => throw Exception('User not found'));
            final token = tokenResult.getOrElse(() => null);
            debugPrint('✅ User data retrieved successfully: ${user.email}');

            debugPrint('🔐 Checking biometric authentication requirements');
            final shouldUseBiometrics =
                await _biometricService.shouldUseBiometrics();
            if (shouldUseBiometrics) {
              debugPrint(
                  '🔐 Biometric authentication required for user: ${user.email}');
              emit(AuthBiometricRequired(user: user, token: token));
            } else {
              debugPrint(
                  '✅ Biometric authentication not required, proceeding with normal auth');
              emit(AuthAuthenticated(user: user, token: token));
            }
          } else {
            debugPrint('❌ Failed to retrieve user data');
            emit(state.copyWith(
              isLoading: false,
              error: _l10n.get('user_data_not_found'),
            ));
          }
        } else {
          debugPrint('ℹ️ User is not authenticated');
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
      // Clear any previous error or success message
      emit(currentState.copyWith(
        isLoading: true,
        error: null,
        successMessage: null,
      ));

      try {
        final result = await _changePasswordUseCase(
          ChangePasswordParams(
            currentPassword: event.currentPassword,
            newPassword: event.newPassword,
          ),
        );

        await result.fold(
          (failure) async {
            emit(currentState.copyWith(
              isLoading: false,
              error: _getErrorMessage(failure),
              successMessage: null,
            ));
          },
          (_) async {
            emit(currentState.copyWith(
              isLoading: false,
              error: null,
              successMessage: _l10n.get('password_changed'),
            ));
          },
        );
      } catch (e) {
        emit(currentState.copyWith(
          isLoading: false,
          error: _l10n.get('unexpected_error'),
          successMessage: null,
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
            // Ensure user data is cached before emitting state
            final currentUserResult = await _getCurrentUserUseCase(NoParams());
            await currentUserResult.fold(
              (failure) async {
                debugPrint('❌ Failed to get cached user: ${failure.message}');
                emit(currentState.copyWith(
                  isLoading: false,
                  error: _getErrorMessage(failure),
                ));
              },
              (cachedUser) async {
                debugPrint('✅ User data cached successfully');
                emit(AuthAuthenticated(
                  user: cachedUser,
                  token: currentState.token,
                  isLoading: false,
                  successMessage: _l10n.get('profile_updated'),
                ));
              },
            );
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
    debugPrint(
        '🔐 Starting biometric authentication for user: ${event.user.email}');
    try {
      // Validate the token if provided
      if (event.token != null) {
        debugPrint('🔑 Validating token for biometric authentication');
        final validateResult = await _validateTokenUseCase(
          ValidateTokenParams(token: event.token!),
        );
        await validateResult.fold(
          (failure) async {
            debugPrint(
                '❌ Token validation failed during biometric auth: ${failure.message}');
            emit(AuthError(message: _getErrorMessage(failure)));
          },
          (isValid) async {
            if (isValid) {
              debugPrint(
                  '✅ Biometric authentication successful with valid token');
              // Ensure user data is cached before emitting state
              final currentUserResult =
                  await _getCurrentUserUseCase(NoParams());
              await currentUserResult.fold(
                (failure) async {
                  debugPrint('❌ Failed to get cached user: ${failure.message}');
                  emit(AuthError(message: _getErrorMessage(failure)));
                },
                (cachedUser) async {
                  debugPrint('✅ User data cached successfully');
                  emit(AuthAuthenticated(user: cachedUser, token: event.token));
                },
              );
            } else {
              debugPrint('❌ Token invalid during biometric auth, signing out');
              await _signOutUseCase(NoParams());
              emit(const AuthUnauthenticated());
            }
          },
        );
      } else {
        debugPrint(
            'ℹ️ No token provided for biometric auth, proceeding without token');
        // Ensure user data is cached before emitting state
        final currentUserResult = await _getCurrentUserUseCase(NoParams());
        await currentUserResult.fold(
          (failure) async {
            debugPrint('❌ Failed to get cached user: ${failure.message}');
            emit(AuthError(message: _getErrorMessage(failure)));
          },
          (cachedUser) async {
            debugPrint('✅ User data cached successfully');
            emit(AuthAuthenticated(user: cachedUser));
          },
        );
      }
    } catch (e) {
      debugPrint('❌ Unexpected error during biometric authentication: $e');
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
