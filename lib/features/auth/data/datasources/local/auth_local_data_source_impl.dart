import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:expense_tracker/features/auth/data/models/hive_user_model.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<HiveUserModel> _userBox;
  final Box<String> _tokenBox;
  final Box<bool> _preferencesBox;

  AuthLocalDataSourceImpl({
    required Box<HiveUserModel> userBox,
    required Box<String> tokenBox,
    required Box<bool> preferencesBox,
  })  : _userBox = userBox,
        _tokenBox = tokenBox,
        _preferencesBox = preferencesBox;

  @override
  Future<HiveUserModel?> getCachedUser() async {
    try {
      final userModel = _userBox.get('current_user');
      return userModel;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(HiveUserModel user) async {
    try {
      await _userBox.put('current_user', user);
    } catch (e) {
      throw Exception('Error caching user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await _userBox.delete('current_user');
    } catch (e) {
      throw Exception('Error clearing cached user: $e');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return _tokenBox.get('access_token');
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      await _tokenBox.put('access_token', token);
    } catch (e) {
      throw Exception('Error caching token: $e');
    }
  }

  @override
  Future<void> clearCachedToken() async {
    try {
      await _tokenBox.delete('access_token');
    } catch (e) {
      throw Exception('Error clearing cached token: $e');
    }
  }

  @override
  Future<bool> getRememberMe() async {
    try {
      return _preferencesBox.get('remember_me') ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> cacheRememberMe(bool value) async {
    try {
      await _preferencesBox.put('remember_me', value);
    } catch (e) {
      throw Exception('Error caching remember me preference: $e');
    }
  }
}
