import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  final bool isLoading;
  final String? error;
  final User? user;
  final String? token;
  final String? successMessage;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.token,
    this.successMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? token,
    String? successMessage,
  });

  @override
  List<Object?> get props => [isLoading, error, user, token, successMessage];
}

class AuthInitial extends AuthState {
  const AuthInitial() : super();

  @override
  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? token,
    String? successMessage,
  }) {
    return AuthInitial();
  }
}

class AuthLoading extends AuthState {
  const AuthLoading() : super(isLoading: true);

  @override
  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? token,
    String? successMessage,
  }) {
    return AuthLoading();
  }
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({
    required User user,
    String? token,
    bool isLoading = false,
    String? error,
    String? successMessage,
  }) : super(
          user: user,
          token: token,
          isLoading: isLoading,
          error: error,
          successMessage: successMessage,
        );

  @override
  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? token,
    String? successMessage,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user!,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? token,
    String? successMessage,
  }) {
    return AuthUnauthenticated();
  }
}

class AuthError extends AuthState {
  const AuthError({
    required String message,
  }) : super(error: message);

  @override
  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? token,
    String? successMessage,
  }) {
    return AuthError(
      message: error ?? this.error!,
    );
  }
}

class AuthSuccess extends AuthState {
  const AuthSuccess({
    required String message,
  }) : super(successMessage: message);

  @override
  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? token,
    String? successMessage,
  }) {
    return AuthSuccess(
      message: successMessage ?? this.successMessage!,
    );
  }
}

extension AuthStateX on AuthState {
  bool get isAuthenticated => this is AuthAuthenticated;
  bool get isLoading =>
      this is AuthLoading ||
      (this is AuthAuthenticated && (this as AuthAuthenticated).isLoading);
  String? get error => this is AuthError
      ? (this as AuthError).error
      : (this is AuthAuthenticated ? (this as AuthAuthenticated).error : null);
  User? get user =>
      this is AuthAuthenticated ? (this as AuthAuthenticated).user : null;
  String? get token =>
      this is AuthAuthenticated ? (this as AuthAuthenticated).token : null;
  String? get successMessage => this is AuthSuccess
      ? (this as AuthSuccess).successMessage
      : (this is AuthAuthenticated
          ? (this as AuthAuthenticated).successMessage
          : null);
}
