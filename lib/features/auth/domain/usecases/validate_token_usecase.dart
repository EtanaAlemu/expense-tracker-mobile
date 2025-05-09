import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class ValidateTokenUseCase implements BaseUseCase<bool, String> {
  final AuthRepository repository;

  ValidateTokenUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String token) async {
    try {
      final isValid = await repository.validateToken(token);
      return Right(isValid.fold(
        (failure) => false,
        (isValid) => isValid,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
