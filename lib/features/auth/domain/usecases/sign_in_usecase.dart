import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });
}

class SignInUseCase implements BaseUseCase<void, SignInParams> {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(SignInParams params) async {
    try {
      await _authRepository.signIn(params.email, params.password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to sign in'));
    }
  }
}
