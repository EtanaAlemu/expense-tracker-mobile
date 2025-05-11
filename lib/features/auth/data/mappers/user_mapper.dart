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
      currency: json['currency']?.toString() ?? 'Birr',
      image: json['image']?.toString(),
      language: json['language']?.toString() ?? 'en',
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'currency': user.currency,
      'image': user.image,
      'language': user.language,
    };
  }

  static Future<Map<String, dynamic>> toUpdateProfileJson(
      dynamic params) async {
    if (params is UpdateUserParams) {
      final json = toJson(params.user);
      if (params.profilePicture != null) {
        final compressedBytes = await _compressImage(params.profilePicture!);
        final base64String = base64Encode(compressedBytes);
        json['image'] = 'data:image/jpeg;base64,$base64String';
      }
      return json;
    } else if (params is User) {
      final json = toJson(params);
      if (params.image != null && params.image!.startsWith('data:image/')) {
        final base64Data = params.image!.split(',')[1];
        final bytes = base64Decode(base64Data);
        final compressedBytes = await FlutterImageCompress.compressWithList(
          bytes,
          minWidth: 800,
          minHeight: 800,
          quality: 80,
        );
        final compressedBase64 = base64Encode(compressedBytes);
        json['image'] = 'data:image/jpeg;base64,$compressedBase64';
      }
      return json;
    }
    throw ArgumentError(
        'Invalid parameter type. Expected UpdateUserParams or User.');
  }

  static HiveUserModel toHiveModel(User user) {
    return HiveUserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      currency: user.currency,
      image: user.image,
      language: user.language,
    );
  }

  static User toEntity(HiveUserModel model) {
    return User(
      id: model.id,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      currency: model.currency,
      image: model.image,
      language: model.language,
    );
  }

  static Future<List<int>> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 800,
      minHeight: 800,
      quality: 80,
    );
    return result ?? await file.readAsBytes();
  }
}
