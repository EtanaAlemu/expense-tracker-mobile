import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/network/api_service.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'package:expense_tracker/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:expense_tracker/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:expense_tracker/features/auth/data/models/api/sign_in_request_model.dart';
import 'package:expense_tracker/features/auth/data/models/api/sign_up_request_model.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/core/error/exceptions.dart';
import 'dart:convert';
import 'package:expense_tracker/features/auth/data/mappers/user_mapper.dart';
import 'package:expense_tracker/features/auth/domain/usecases/update_user_usecase.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final ApiService _apiService;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
    required ApiService apiService,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo,
        _apiService = apiService;

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getCachedUser();
      if (user == null) {
        return Left(CacheFailure('No user found'));
      }
      return Right(UserMapper.toEntity(user));
    } catch (e) {
      return Left(CacheFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signIn(String email, String password,
      {bool rememberMe = false, bool isGuest = false}) async {
    try {
      if (isGuest) {
        // Handle guest user locally
        final guestUser = User(
          id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          firstName: 'Guest',
          lastName: 'User',
          currency: 'BIRR',
          isGuest: true,
          language: 'en',
        );
        await _localDataSource.cacheUser(UserMapper.toHiveModel(guestUser));
        return Right(guestUser);
      }

      if (await _networkInfo.isConnected) {
        try {
          final response = await _remoteDataSource.signIn(
            SignInRequestModel(email: email, password: password),
          );

          if (response.user == null) {
            return Left(AuthFailure(response.message ?? 'User data not found'));
          }

          if (response.token == null) {
            return Left(AuthFailure('Authentication token not received'));
          }

          final user = response.user!.toEntity();
          await _localDataSource.cacheUser(UserMapper.toHiveModel(user));
          await _localDataSource.cacheToken(response.token!);
          await _localDataSource.cacheRememberMe(rememberMe);
          _apiService.setToken(response.token!);
          return Right(user);
        } on AuthException catch (e) {
          // Clear any cached data on authentication failure
          await _localDataSource.clearCachedUser();
          await _localDataSource.clearCachedToken();
          _apiService.clearToken();
          return Left(ServerFailure(e.message));
        } catch (e) {
          return Left(ServerFailure('Failed to sign in: $e'));
        }
      } else {
        // Only allow offline sign-in if we have valid cached credentials
        final cachedUser = await _localDataSource.getCachedUser();
        final cachedToken = await _localDataSource.getCachedToken();

        if (cachedUser == null || cachedToken == null) {
          return Left(NetworkFailure(
              'No internet connection and no cached credentials'));
        }

        final user = UserMapper.toEntity(cachedUser);
        if (user.email != email) {
          return Left(CacheFailure('Email does not match cached user'));
        }

        _apiService.setToken(cachedToken);
        return Right(user);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to sign in: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final response = await _remoteDataSource.signUp(
        SignUpRequestModel(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
        ),
      );

      if (response.user != null) {
        final user = response.user!.toEntity();
        // Don't cache user or token during registration since email verification is required
        return Right(user);
      } else {
        return Left(AuthFailure(response.message ?? 'Failed to create user'));
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Authentication failed'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _localDataSource.clearCachedUser();
      await _localDataSource.clearCachedToken();
      _apiService.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to sign out: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(UpdateUserParams params) async {
    try {
      final userJson = await UserMapper.toUpdateProfileJson(params);
      final response = await _remoteDataSource.updateProfile(userJson);
      final updatedUser = UserMapper.fromJson(response['user']);
      await _localDataSource.cacheUser(UserMapper.toHiveModel(updatedUser));
      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
      String currentPassword, String newPassword) async {
    try {
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.changePassword(currentPassword, newPassword);
        return const Right(null);
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to change password: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final token = await _localDataSource.getCachedToken();
      return Right(token != null);
    } catch (e) {
      return Left(CacheFailure('Failed to check sign in status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
      String token, String newPassword) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection'));
      }
      await _remoteDataSource.resetPassword(token, newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final result = await _remoteDataSource.forgotPassword(email);
      return Right(result);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getCachedToken() async {
    try {
      final token = await _localDataSource.getCachedToken();
      return Right(token);
    } catch (e) {
      return Left(CacheFailure('Failed to get cached token: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken(String token) async {
    try {
      // Parse the JWT token to check expiration
      final tokenData = _parseJwt(token);
      if (tokenData == null) {
        return Right(false);
      }

      // Check if token is expired
      final expiration =
          DateTime.fromMillisecondsSinceEpoch(tokenData['exp'] * 1000);
      final isValid = DateTime.now().isBefore(expiration);

      return Right(isValid);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> getRememberMe() async {
    try {
      final rememberMe = await _localDataSource.getRememberMe();
      return Right(rememberMe);
    } catch (e) {
      return Left(CacheFailure('Failed to get remember me preference: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearRememberMe() async {
    try {
      await _localDataSource.cacheRememberMe(false);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear remember me preference: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String otp, String email) async {
    try {
      await _remoteDataSource.verifyOtp(otp, email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendVerificationCode(String email) async {
    try {
      final result = await _remoteDataSource.resendVerificationCode(email);
      return Right(result);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Map<String, dynamic>? _parseJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return json.decode(decoded);
    } catch (e) {
      return null;
    }
  }
}
