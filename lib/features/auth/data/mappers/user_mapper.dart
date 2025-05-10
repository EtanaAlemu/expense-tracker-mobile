import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:expense_tracker/features/auth/data/models/hive_user_model.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/domain/usecases/update_user_usecase.dart';

class UserMapper {
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      image: json['image']?.toString(),
      currency: json['currency']?.toString(),
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'image': user.image,
      'currency': user.currency,
    };
  }

  static Future<Map<String, dynamic>> toUpdateProfileJson(
      UpdateUserParams params) async {
    final Map<String, dynamic> data = toJson(params.user);

    if (params.profilePicture != null) {
      final compressedBytes = await _compressImage(params.profilePicture!);
      final base64String = base64Encode(compressedBytes);
      data['image'] = 'data:image/jpeg;base64,$base64String';
    }

    return data;
  }

  static Future<List<int>> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 512,
      minHeight: 512,
      quality: 60,
    );
    return result ?? await file.readAsBytes();
  }

  static HiveUserModel toHiveModel(User user) {
    return HiveUserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      image: user.image,
      currency: user.currency,
    );
  }

  static User toEntity(HiveUserModel model) {
    return User(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      image: model.image,
      currency: model.currency,
    );
  }
}
