import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/data/models/api/user_model.dart';

class AuthResponseModel {
  final String message;
  final UserModel user;
  final String token;

  AuthResponseModel({
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'],
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}

class UserResponseModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  const UserResponseModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }

  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      currency: 'Birr',
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email];
}
