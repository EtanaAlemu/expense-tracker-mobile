import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/data/models/api/user_model.dart';

class AuthResponseModel {
  final String? message;
  final UserModel? user;
  final String? token;

  AuthResponseModel({
    this.message,
    this.user,
    this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      message: json['message'] as String?,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user?.toJson(),
      'token': token,
    };
  }
}

class UserResponseModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? currency;
  final String? language;
  final String? image;

  const UserResponseModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.currency,
    this.language,
    this.image,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      currency: json['currency'],
      language: json['language'],
      image: json['image'],
    );
  }

  User toEntity() {
    return User(
      id: id.isNotEmpty ? id : '',
      firstName: firstName.isNotEmpty ? firstName : '',
      lastName: lastName.isNotEmpty ? lastName : '',
      email: email.isNotEmpty ? email : '',
      currency: currency ?? 'Birr',
      language: language ?? 'en',
      image: image ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [id, firstName, lastName, email, currency, language, image];
}
