import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/features/auth/domain/usecases/check_remember_me_usecase.dart';
import 'package:expense_tracker/features/auth/domain/usecases/validate_token_on_start_usecase.dart';

class CheckAuthStatusUseCase extends UseCase<bool, NoParams> {
  final AuthRepository repository;
  final CheckRememberMeUseCase checkRememberMeUseCase;
  final ValidateTokenOnStartUseCase validateTokenOnStartUseCase;

  CheckAuthStatusUseCase(
    this.repository,
    this.checkRememberMeUseCase,
    this.validateTokenOnStartUseCase,
  );

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    // 1. Check remember me preference
    final rememberMeResult = await checkRememberMeUseCase(params);
    if (rememberMeResult.isLeft()) return rememberMeResult;
    if (!rememberMeResult.getOrElse(() => false)) return const Right(false);

    // 2. Validate token
    return await validateTokenOnStartUseCase(params);
  }
}
