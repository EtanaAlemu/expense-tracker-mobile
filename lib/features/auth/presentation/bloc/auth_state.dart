part of 'auth_bloc.dart';



@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
  const factory AuthState.passwordChanged() = _PasswordChanged;
  const factory AuthState.passwordReset() = _PasswordReset;
  const factory AuthState.userUpdated(User user) = _UserUpdated;
}
