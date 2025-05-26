import 'package:dio/dio.dart';
import 'package:expense_tracker/core/constants/api_constants.dart';
import 'package:expense_tracker/core/error/exceptions.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/features/auth/data/models/api/auth_response_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/reset_password_request_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/reset_password_response_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/sign_in_request_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/sign_up_request_model.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/data/datasources/remote/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;
  final AppLocalizations _l10n;

  AuthRemoteDataSourceImpl(this._apiService, this._l10n);

  @override
  Future<AuthResponseModel> signIn(SignInRequestModel request) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.signIn,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        throw AuthException(response.data['message'] ?? 'Invalid credentials');
      } else {
        throw AuthException('Failed to sign in: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AuthException(
            e.response?.data['message'] ?? 'Invalid credentials');
      }
      throw AuthException('Failed to sign in: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to sign in: $e');
    }
  }

  @override
  Future<AuthResponseModel> signUp(SignUpRequestModel request) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.signUp,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        final message =
            response.data['message'] as String? ?? 'Failed to sign up';
        throw AuthException(message);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final message =
            e.response?.data['message'] as String? ?? 'Failed to sign up';
        throw AuthException(message);
      }
      throw AuthException('Failed to sign up: ${e.message}');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Failed to sign up: $e');
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.changePassword,
        data: {
          'currentPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw AuthException(_l10n.get('change_password_failed'));
      }
    } on DioException catch (_) {
      throw AuthException(_l10n.get('change_password_failed'));
    } catch (_) {
      throw AuthException(_l10n.get('change_password_failed'));
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return response.data['message'] as String;
      } else {
        throw AuthException(
            response.data['message'] ?? 'Failed to send reset link');
      }
    } catch (e) {
      throw AuthException('Failed to send reset link. Please try again.');
    }
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(
      String token, String newPassword) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.resetPassword,
        data: ResetPasswordRequestModel(
          token: token,
          newPassword: newPassword,
        ).toJson(),
      );

      if (response.statusCode == 200) {
        return ResetPasswordResponseModel.fromJson(response.data);
      } else {
        throw AuthException(
            'Failed to reset password: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw AuthException('Failed to reset password: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to reset password: $e');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    // Implementation needed
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.dio.put(
        ApiConstants.updateProfile,
        data: userData,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw AuthException(
            'Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw AuthException('Failed to update profile: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to update profile: $e');
    }
  }

  @override
  Future<void> verifyOtp(String otp, String email) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.verifyOtp,
        data: {
          'email': email,
          'code': otp,
        },
      );

      if (response.statusCode != 200) {
        throw AuthException(
          response.data['message'] ?? 'OTP verification failed',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AuthException(
          e.response?.data['message'] ?? 'Invalid or expired verification code',
        );
      }
      throw AuthException('Failed to verify OTP: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to verify OTP: $e');
    }
  }

  @override
  Future<String> resendVerificationCode(String email) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.resendVerificationCode,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return response.data['message'] as String;
      } else {
        throw AuthException(
          response.data['message'] ?? 'Failed to resend verification code',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AuthException(
          e.response?.data['message'] ?? 'Email is already verified',
        );
      } else if (e.response?.statusCode == 404) {
        throw AuthException('User not found');
      }
      throw AuthException('Failed to resend verification code: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to resend verification code: $e');
    }
  }
}
