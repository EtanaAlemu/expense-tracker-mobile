import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';

abstract class BaseUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

class UserParams {
  final String userId;
  const UserParams({
    required this.userId,
  });
}
