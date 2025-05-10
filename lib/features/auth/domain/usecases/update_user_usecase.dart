import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/core/usecase/usecase.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserParams extends Equatable {
  final User user;
  final File? profilePicture;

  const UpdateUserParams({
    required this.user,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [user, profilePicture];
}

class UpdateUserUseCase implements UseCase<User, UpdateUserParams> {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) async {
    return await repository.updateUser(params);
  }
}
