import 'package:expense_tracker/features/auth/data/models/hive_user_model.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';

class UserMapper {
  static HiveUserModel toHiveModel(User user) {
    return HiveUserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
      currency: user.currency,
    );
  }

  static User toEntity(HiveUserModel model) {
    return User(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      password: model.password,
      currency: model.currency,
    );
  }
}
