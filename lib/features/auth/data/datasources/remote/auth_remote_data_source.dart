import 'package:expense_tracker/features/auth/data/models/api/auth_response_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/forgot_password_response_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/sign_in_request_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/sign_up_request_model.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> signIn(SignInRequestModel request);
  Future<AuthResponseModel> signUp(SignUpRequestModel request);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> updateUser(User user);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<ForgotPasswordResponseModel> forgotPassword(String email);
}
