import 'package:dio/dio.dart';
import 'package:expense_tracker/core/constants/api_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiService {
  final Dio _dio;
  final Box<String> _tokenBox;

  ApiService(this._dio, this._tokenBox) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add token to headers if it exists

    final token = _tokenBox.get('access_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  Dio get dio => _dio;
}
