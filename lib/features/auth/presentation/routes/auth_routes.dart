import 'package:flutter/material.dart';
import 'package:expense_tracker/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:expense_tracker/features/auth/presentation/pages/sign_in_page.dart';
import 'package:expense_tracker/features/auth/presentation/pages/sign_up_page.dart';

class AuthRoutes {
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      signIn: (context) => const SignInPage(),
      signUp: (context) => const SignUpPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
    };
  }
}
