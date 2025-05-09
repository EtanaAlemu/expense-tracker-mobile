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
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      if (await _networkInfo.isConnected) {
        try {
          final response = await _remoteDataSource.signIn(
            SignInRequestModel(email: email, password: password),
          );

          await _localDataSource.cacheUser(response.user.toEntity());
          await _localDataSource.cacheToken(response.token);
          _apiService.setToken(response.token);
          return Right(response.user.toEntity());
        } catch (e) {
          return await _tryOfflineSignIn(email, password);
        }
      } else {
        return await _tryOfflineSignIn(email, password);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to sign in: $e'));
    }
  }

  Future<Either<Failure, User>> _tryOfflineSignIn(
      String email, String password) async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser == null) {
        return Left(CacheFailure('No cached user found'));
      }
      if (cachedUser.email != email) {
        return Left(CacheFailure('Email does not match cached user'));
      }
      final token = await _localDataSource.getCachedToken();
      if (token == null) {
        return Left(CacheFailure('No cached token found'));
      }
      _apiService.setToken(token);
      return Right(cachedUser);
    } catch (e) {
      return Left(CacheFailure('Failed to sign in offline: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
      String email, String password, String firstName, String lastName) async {
    try {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.signUp(
          SignUpRequestModel(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
          ),
        );

        await _localDataSource.cacheUser(response.user.toEntity());
        await _localDataSource.cacheToken(response.token);
        _apiService.setToken(response.token);
        return Right(response.user.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to sign up: $e'));
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
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      await _localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Failed to update user: $e'));
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
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection'));
      }
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
