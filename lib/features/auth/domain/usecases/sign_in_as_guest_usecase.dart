import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignInAsGuestUseCase extends UseCase<User, NoParams> {
  final AuthRepository repository;

  SignInAsGuestUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    // Create a guest user with temporary credentials
    return await repository.signUp(
      'guest_${DateTime.now().millisecondsSinceEpoch}@guest.com',
      'guest_password',
      'Guest',
      'User',
    );
  }
}
