import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const SignInEvent({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password, firstName, lastName];
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

class SignInAsGuestEvent extends AuthEvent {
  const SignInAsGuestEvent();
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class ResetPasswordEvent extends AuthEvent {
  final String token;
  final String newPassword;

  const ResetPasswordEvent({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class UpdateCurrencyEvent extends AuthEvent {
  final String currency;

  const UpdateCurrencyEvent(this.currency);

  @override
  List<Object?> get props => [currency];
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class UpdateProfileEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final File? profilePicture;

  const UpdateProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, profilePicture];
}
