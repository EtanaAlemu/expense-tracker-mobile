import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/domain/usecases/base_usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class GetTokenUseCase implements BaseUseCase<String?, void> {
  final AuthRepository _authRepository;

  GetTokenUseCase(this._authRepository);

  @override
  Future<Either<Failure, String?>> call(void params) async {
    try {
      final result = await _authRepository.getCachedToken();
      return result;
    } catch (e) {
      return Left(ServerFailure('Failed to get token'));
    }
  }
}
