import 'package:expense_tracker/core/domain/repositories/base_repository.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';

abstract class UserRepository extends BaseRepository<User> {
  Future<User?> getUserByEmail(String email);
  Future<bool> isEmailExists(String email);
  Future<User?> authenticate(String email, String password);
}
