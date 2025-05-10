import 'package:expense_tracker_mobile/core/logic/app_cubit.dart';
import 'package:expense_tracker_mobile/core/theme/colors.dart';
import 'package:expense_tracker_mobile/features/auth/presentation/auth_screen.dart';
import 'package:expense_tracker_mobile/features/auth/presentation/reset_password_screen.dart';
import 'package:expense_tracker_mobile/features/main/presentation/main.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_links/app_links.dart';
import 'package:expense_tracker/core/presentation/bloc/theme_bloc.dart';
import 'dart:async';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initAppLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  // Initialize app_links
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
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        debugPrint('Initial deep link: $initialUri');
        _handleDeepLink(initialUri);
      }
    } on PlatformException {
      debugPrint('Failed to get initial URI');
    }
  }

  // Handle deep links
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
          if (context.read<AppCubit>().state.authState.user != null) {
            // If user is logged in, log them out first
            context.read<AppCubit>().logout();
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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          initialRoute: '/',
          themeMode: state is ThemeLoaded ? state.themeMode : ThemeMode.system,
          routes: {
            '/': (context) => BlocConsumer<AppCubit, AppState>(
                  listener: (context, state) {
                    debugPrint(
                      "App: State changed - username: ${state.settingsState.username}, isAuthenticating: ${state.authState.isAuthenticating}",
                    );
                  },
                  builder: (context, state) {
                    debugPrint(
                      "App: Building route with state - username: ${state.settingsState.username}, isAuthenticating: ${state.authState.isAuthenticating}",
                    );

                    if (state.authState.isAuthenticating) {
                      return Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ThemeColors.getColorScheme(
                                    state.themeState.themeMode == ThemeMode.dark
                                        ? Brightness.dark
                                        : Brightness.light,
                                  ).primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Authenticating...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: state.themeState.themeMode ==
                                          ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state.authState.user == null) {
                      return AuthScreen(error: state.authState.error);
                    }

                    return const MainScreen();
                  },
                ),
            '/reset-password': (context) {
              final token =
                  ModalRoute.of(context)?.settings.arguments as String?;
              if (token != null) {
                return ResetPasswordScreen(token: token);
              } else {
                return AuthScreen(error: 'Invalid password reset link');
              }
            },
          },
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ThemeColors.getColorScheme(
              state is ThemeLoaded
                  ? state.themeMode == ThemeMode.dark
                      ? Brightness.dark
                      : Brightness.light
                  : Brightness.light,
            ),
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith((
                Set<MaterialState> states,
              ) {
                TextStyle style = const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                );
                if (states.contains(MaterialState.selected)) {
                  style = style.merge(
                    const TextStyle(fontWeight: FontWeight.w600),
                  );
                }
                return style;
              }),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ThemeColors.getColorScheme(
              state is ThemeLoaded
                  ? state.themeMode == ThemeMode.dark
                      ? Brightness.dark
                      : Brightness.light
                  : Brightness.dark,
            ),
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith((
                Set<MaterialState> states,
              ) {
                TextStyle style = const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                );
                if (states.contains(MaterialState.selected)) {
                  style = style.merge(
                    const TextStyle(fontWeight: FontWeight.w600),
                  );
                }
                return style;
              }),
            ),
          ),
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
        );
      },
    );
  }
}
