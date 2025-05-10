import 'package:hive/hive.dart';

part 'hive_user_model.g.dart';

@HiveType(typeId: 0)
class HiveUserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String? image;

  @HiveField(5)
  final String? currency;

  HiveUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
    this.currency,
  });
}
