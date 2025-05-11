import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;
  final bool rememberMe;

  const SignInParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Either<Failure, User>> call(SignInParams params) async {
    return await _repository.signIn(
      params.email,
      params.password,
      rememberMe: params.rememberMe,
    );
  }
}
