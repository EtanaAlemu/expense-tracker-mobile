import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';

@injectable
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final context = options.extra['context'] as BuildContext?;
    if (context != null) {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      final token = authBloc.token;

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return super.onRequest(options, handler);
  }
}
