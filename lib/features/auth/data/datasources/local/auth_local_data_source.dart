import 'package:expense_tracker/features/auth/data/models/hive_user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(HiveUserModel user);
  Future<HiveUserModel?> getCachedUser();
  Future<void> clearCachedUser();
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearCachedToken();
  Future<void> cacheRememberMe(bool value);
  Future<bool> getRememberMe();
}
