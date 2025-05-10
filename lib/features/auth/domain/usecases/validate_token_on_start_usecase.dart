import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class ValidateTokenOnStartUseCase extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  ValidateTokenOnStartUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    // 1. Get cached token
    final tokenResult = await repository.getCachedToken();
    if (tokenResult.isLeft()) {
      return Left(tokenResult.fold(
        (failure) => failure,
        (_) => CacheFailure('Failed to get token'),
      ));
    }

    final token = tokenResult.getOrElse(() => null);
    if (token == null) {
      return const Right(false);
    }

    // 2. Validate token
    final validationResult = await repository.validateToken(token);
    if (validationResult.isLeft()) {
      // If validation fails, clear the token
      await repository.signOut();
      return Left(validationResult.fold(
        (failure) => failure,
        (_) => ServerFailure('Token validation failed'),
      ));
    }

    return validationResult;
  }
}
