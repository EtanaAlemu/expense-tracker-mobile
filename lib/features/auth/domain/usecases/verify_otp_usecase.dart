import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpParams {
  final String otp;
  final String email;

  VerifyOtpParams({required this.otp, required this.email});
}

class VerifyOtpUseCase implements UseCase<void, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.otp, params.email);
  }
}
