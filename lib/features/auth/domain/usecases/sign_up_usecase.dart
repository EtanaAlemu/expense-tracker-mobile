import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignUpParams {
  final User user;
  final String password;

  const SignUpParams({
    required this.user,
    required this.password,
  });
}

class SignUpUseCase implements BaseUseCase<void, SignUpParams> {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    try {
      await _authRepository.signUp(params.user.email, params.password, params.user.firstName, params.user.lastName);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to sign up'));
    }
  }
}
