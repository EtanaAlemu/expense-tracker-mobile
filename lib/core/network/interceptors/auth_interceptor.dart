import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';

@injectable
class AuthInterceptor extends Interceptor {
  final AuthBloc authBloc;

  AuthInterceptor(this.authBloc);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final state = authBloc.state;
    if (state is AuthAuthenticated) {
      options.headers['Authorization'] = 'Bearer ${state.token}';
    }
    handler.next(options);
  }
}
