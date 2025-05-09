import 'package:expense_tracker/features/auth/domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<User?> getCachedUser();
  Future<void> cacheUser(User user);
  Future<void> clearCachedUser();
  Future<String?> getCachedToken();
  Future<void> cacheToken(String token);
  Future<void> clearCachedToken();
}
