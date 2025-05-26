import 'package:expense_tracker/features/auth/domain/entities/user.dart';

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? currency;
  String? language;
  String? image;

  UserModel({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.currency = 'BIRR',
    this.language = 'en',
    this.image = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      currency: json['currency'] ?? 'BIRR',
      language: json['language'] ?? 'en',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      'email': email ?? '',
      'currency': currency ?? 'BIRR',
      'language': language ?? 'en',
      'image': image ?? '',
    };
  }

  User toEntity() {
    return User(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      currency: currency ?? 'BIRR',
      language: language ?? 'en',
      image: image ?? '',
    );
  }
}
