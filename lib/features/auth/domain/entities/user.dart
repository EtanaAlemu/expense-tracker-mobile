import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String currency;
  final bool isGuest;
  final String language;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.currency,
    this.isGuest = false,
    this.language = 'en',
  });

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? image,
    String? currency,
    bool? isGuest,
    String? language,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      currency: currency ?? this.currency,
      isGuest: isGuest ?? this.isGuest,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'currency': currency,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      image: json['image'] as String?,
      currency: json['currency'] as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        image,
        currency,
        isGuest,
        language,
      ];
}
