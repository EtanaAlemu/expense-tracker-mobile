class ApiConstants {
  // static const String baseUrl = 'https://r7fbff17-5000.uks1.devtunnels.ms/api';
  static const String baseUrl = 'https://expense-tracker-backend-eight.vercel.app/api';

  // Auth endpoints
  static const String signIn = '/auth/login';
  static const String signUp = '/auth/register';
  static const String changePassword = '/auth/change-password';
  static const String forgotPassword = '/auth/forgot-password';
  static const String refreshToken = '/auth/refresh-token';
  static const String resetPassword = '/auth/reset-password';
  static const String updateProfile = '/users/profile';
  static const String verifyOtp = '/auth/verify';
  static const String resendVerificationCode = '/auth/resend-verification';
  // Category endpoints
  static const String categories = '/categories';
  static const String transactions = '/transactions';
}
