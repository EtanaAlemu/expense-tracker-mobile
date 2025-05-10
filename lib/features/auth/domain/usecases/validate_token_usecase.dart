import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class ValidateTokenParams {
  final String token;

  const ValidateTokenParams({required this.token});
}

class ValidateTokenUseCase extends UseCase<bool, ValidateTokenParams> {
  final AuthRepository repository;

  ValidateTokenUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateTokenParams params) async {
    return await repository.validateToken(params.token);
  }
}
