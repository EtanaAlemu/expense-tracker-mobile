import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/features/main/presentation/pages/main_screen.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/pages/auth_screen.dart';
import 'package:expense_tracker/features/auth/presentation/widgets/reset_password_screen.dart';
import 'package:expense_tracker/injection/injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/core/services/hive/hive_registry.dart';
import 'package:expense_tracker/core/presentation/bloc/theme_bloc.dart';
import 'package:expense_tracker/core/localization/app_localizations_delegate.dart';
import 'package:app_links/app_links.dart';
import 'package:expense_tracker/core/services/connectivity/connectivity_service.dart';
import 'dart:async';
import 'package:expense_tracker/core/services/notification/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive using HiveRegistry
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await HiveRegistry.initialize(appDocumentDir.path);

  // Initialize dependencies
  await configureDependencies();

  // Initialize notification service from dependency injection
  final notificationService = getIt<NotificationService>();
  await notificationService.requestPermissions();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<CategoryBloc>(),
          lazy: false, // Create immediately to ensure AuthBloc is available
        ),
        BlocProvider(create: (context) => GetIt.I<TransactionBloc>()),
        BlocProvider<ThemeBloc>(
          create: (context) =>
              GetIt.instance<ThemeBloc>()..add(ThemeInitialized()),
        ),
      ],
      child: const AppRoot(),
    ),
  );
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  late ConnectivityService _connectivityService;

  @override
  void initState() {
    super.initState();
    initAppLinks();
    _connectivityService = GetIt.I<ConnectivityService>();
    _connectivityService.initialize();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _connectivityService.dispose();
    super.dispose();
  }

  Future<void> initAppLinks() async {
    _appLinks = AppLinks();

    // Handle app links while the app is opened
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        debugPrint('Got URI while app is running: $uri');
        _handleDeepLink(uri);
      },
      onError: (error) {
        debugPrint('Error getting URI: $error');
      },
    );

    // Get the initial URI if the app was opened with a deep link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('Initial deep link: $initialUri');
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial URI: $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Handling deep link: $uri');

    // Check for forgotpassword in the path
    if (uri.pathSegments.contains('forgotpassword')) {
      // Extract token from query parameters
      final token = uri.queryParameters['token'];
      if (token != null && token.isNotEmpty) {
        debugPrint('Deep link contains reset token: $token');

        // Navigate to the reset password screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // First, ensure we're on the auth screen
          if (context.read<AuthBloc>().state.isAuthenticated) {
            // If user is logged in, log them out first
            context.read<AuthBloc>().add(const SignOutEvent());
          }

          // Then navigate to reset password screen
          _navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(token: token),
            ),
          );
        });
      } else {
        debugPrint('Reset password deep link missing token');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeBloc>().state;
    final authState = context.watch<AuthBloc>().state;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final locale = state is AuthAuthenticated && state.user != null
            ? Locale(state.user!.language)
            : const Locale('en');

        return MaterialApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState is ThemeLoaded
              ? themeState.themeMode
              : ThemeMode.system,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('am'), // Amharic
          ],
          localeListResolutionCallback: (locales, supportedLocales) {
            // force Flutter's built-in widgets to fall back if needed
            final actual = locales?.first;
            if (actual != null && ['en', 'am'].contains(actual.languageCode)) {
              return actual;
            }
            return const Locale('en');
          },
          home: authState.isAuthenticated
              ? const MainScreen()
              : const AuthScreen(),
          routes: {
            '/auth': (context) => const AuthScreen(),
            '/home': (context) => const MainScreen(),
            '/reset-password': (context) {
              final token =
                  ModalRoute.of(context)?.settings.arguments as String?;
              if (token != null) {
                return ResetPasswordScreen(token: token);
              } else {
                return const AuthScreen();
              }
            },
          },
        );
      },
    );
  }
}
