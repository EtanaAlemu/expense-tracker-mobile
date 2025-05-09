import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserParams {
  final User user;

  const UpdateUserParams({
    required this.user,
  });
}

class UpdateUserUseCase implements BaseUseCase<void, UpdateUserParams> {
  final AuthRepository _authRepository;

  UpdateUserUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(UpdateUserParams params) async {
    try {
      await _authRepository.updateUser(params.user);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update user'));
    }
  }
}
