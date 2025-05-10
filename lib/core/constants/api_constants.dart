class ApiConstants {
  static const String baseUrl = 'https://r7fbff17-5000.uks1.devtunnels.ms/api';

  // Auth endpoints
  static const String signIn = '/auth/login';
  static const String signUp = '/auth/register';
  static const String changePassword = '/auth/change-password';
  static const String forgotPassword = '/auth/forgot-password';
  static const String refreshToken = '/auth/refresh-token';
  static const String resetPassword = '/auth/reset-password';
  static const String updateProfile = '/users/profile';

  // Category endpoints
  static const String categories = '/categories';
  static const String transactions = '/transactions';
}
