import 'package:dio/dio.dart';
import 'package:expense_tracker/core/constants/api_constants.dart';
import 'package:expense_tracker/core/error/exceptions.dart';
import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/features/auth/data/models/api/auth_response_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/forgot_password_request_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/forgot_password_response_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/reset_password_request_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/reset_password_response_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/sign_in_request_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/sign_up_request_model.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/data/datasources/remote/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

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
        throw AuthException('Failed to sign up: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw AuthException('Failed to sign up: ${e.message}');
    } catch (e) {
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
        throw AuthException(
            'Failed to change password: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw AuthException('Failed to change password: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to change password: $e');
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
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> userData) async {
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
}
