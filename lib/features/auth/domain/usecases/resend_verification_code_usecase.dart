import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class ResendVerificationCodeParams {
  final String email;

  ResendVerificationCodeParams({required this.email});
}

class ResendVerificationCodeUseCase
    implements UseCase<String, ResendVerificationCodeParams> {
  final AuthRepository repository;

  ResendVerificationCodeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
      ResendVerificationCodeParams params) async {
    return await repository.resendVerificationCode(params.email);
  }
}
