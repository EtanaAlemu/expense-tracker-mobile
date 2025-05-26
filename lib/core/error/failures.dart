import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String? message])
      : super(message ?? 'Server error occurred');
}

class CacheFailure extends Failure {
  const CacheFailure([String? message])
      : super(message ?? 'Cache error occurred');
}

class NetworkFailure extends Failure {
  const NetworkFailure([String? message])
      : super(message ?? 'Network error occurred');
}

class UnknownFailure extends Failure {
  const UnknownFailure([String? message])
      : super(message ?? 'An unknown error occurred');
}

class AuthFailure extends Failure {
  const AuthFailure([String? message])
      : super(message ?? 'Authentication failed');

  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure([String? message])
      : super(message ?? 'Validation failed');

  @override
  List<Object> get props => [message];
}
