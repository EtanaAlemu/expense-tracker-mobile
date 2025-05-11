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
import 'package:expense_tracker/injection/injection.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/core/services/hive/hive_registry.dart';
import 'package:expense_tracker/core/presentation/bloc/theme_bloc.dart';
import 'package:expense_tracker/core/localization/app_localizations_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive using HiveRegistry
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await HiveRegistry.initialize(appDocumentDir.path);

  // Initialize dependencies
  await configureDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (context) => GetIt.I<CategoryBloc>()),
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

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  Locale _getFlutterSupportedLocale(Locale actualLocale) {
    // Flutter's delegates support only 'en' and 'am'
    if (['en', 'am'].contains(actualLocale.languageCode)) {
      return actualLocale;
    }
    // Fallback to 'en' to avoid Material/Cupertino warnings
    return const Locale('en');
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
            // Locale('om'), // Afaan Oromoo
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
          },
        );
      },
    );
  }
}
