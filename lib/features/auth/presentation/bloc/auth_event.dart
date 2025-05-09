part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signIn({
    required String email,
    required String password,
  }) = SignIn;

  const factory AuthEvent.signOut() = SignOut;

  const factory AuthEvent.checkAuthStatus() = CheckAuthStatus;

  const factory AuthEvent.signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) = SignUp;

  const factory AuthEvent.updateUser({
    required User user,
  }) = UpdateUser;

  const factory AuthEvent.changePassword({
    required String currentPassword,
    required String newPassword,
  }) = ChangePassword;

  const factory AuthEvent.resetPassword({
    required String token,
    required String newPassword,
  }) = ResetPassword;

  const factory AuthEvent.forgotPassword({
    required String email,
  }) = ForgotPassword;
}
