import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/routes/auth_routes.dart';
import 'package:expense_tracker/injection/injection.dart';
import 'package:expense_tracker/core/services/hive/hive_registry.dart';
import 'package:expense_tracker/core/widgets/error_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    debugPrint('Initializing Hive...');
    await HiveRegistry.initialize();
    debugPrint('Hive initialized successfully');

    debugPrint('Configuring dependencies...');
    await configureDependencies();
    debugPrint('Dependencies configured successfully');

    debugPrint('Starting app...');
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('Error during initialization: $e');
    debugPrint('Stack trace: $stackTrace');

    runApp(
      MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            title: 'Failed to initialize app',
            message: 'Please try restarting the app',
            onRetry: () {
              // Restart the app
              main();
            },
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final authBloc = getIt<AuthBloc>();
      final categoryBloc = getIt<CategoryBloc>();
      debugPrint('AuthBloc successfully retrieved from GetIt');

      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => authBloc..add(CheckAuthStatus())),
          BlocProvider(create: (context) => categoryBloc),
        ],
        child: MaterialApp(
          title: 'Expense Tracker',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: AuthRoutes.signIn,
          routes: AuthRoutes.getRoutes(),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Error creating AuthBloc: $e');
      debugPrint('Stack trace: $stackTrace');

      return MaterialApp(
        home: Scaffold(
          body: AppErrorWidget(
            title: 'Failed to start app',
            message: 'Please try restarting the app',
            onRetry: () {
              // Restart the app
              main();
            },
          ),
        ),
      );
    }
  }
}
