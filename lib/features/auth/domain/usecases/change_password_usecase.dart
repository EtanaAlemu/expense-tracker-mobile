import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

class ChangePasswordUseCase implements BaseUseCase<void, ChangePasswordParams> {
  final AuthRepository _authRepository;

  ChangePasswordUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    try {
      await _authRepository.changePassword(
          params.currentPassword, params.newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to change password'));
    }
  }
}
