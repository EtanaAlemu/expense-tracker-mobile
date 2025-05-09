import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp(
      String email, String password, String firstName, String lastName);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, void>> changePassword(
      String currentPassword, String newPassword);
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, void>> resetPassword(String token, String newPassword);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, String?>> getCachedToken();
  Future<Either<Failure, bool>> validateToken(String token);
}
