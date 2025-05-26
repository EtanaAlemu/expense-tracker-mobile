import 'package:expense_tracker/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/category/domain/usecases/get_categories.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/get_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/main/presentation/pages/home_page.dart';
import 'package:expense_tracker/features/transaction/presentation/pages/transactions_page.dart';
import 'package:expense_tracker/features/category/presentation/pages/categories_page.dart';
import 'package:expense_tracker/features/main/presentation/pages/profile_page.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:expense_tracker/features/transaction/domain/usecases/add_transaction.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  DateTime? _lastBackPressTime;

  List<Widget> get _pages => [
        HomePage(onViewAll: () => setState(() => _currentIndex = 1)),
        const TransactionsPage(),
        const CategoriesPage(),
        ProfilePage(
            addTransaction: GetIt.I<AddTransaction>(),
            getTransactions: GetIt.I<GetTransactions>(),
            getCategories: GetIt.I<GetCategories>(),
            getCurrentUser: GetIt.I<GetCurrentUserUseCase>()),
      ];

  Future<bool> _onWillPop() async {
    // If we're not on the home page, navigate to home page
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }

    // If we're on the home page, handle double back press to exit
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context).get('press_back_again_to_exit')),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
          ),
        );
      }
      return false;
    }

    // If we get here, it means we're on the home screen and it's the second back press within 2 seconds
    SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (!state.isAuthenticated) {
          print('⚠️ User not authenticated, redirecting to auth screen');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed('/auth');
            }
          });
        }

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            await _onWillPop();
          },
          child: Scaffold(
            body: _pages[_currentIndex],
            bottomNavigationBar: NavigationBar(
              height: 65,
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              elevation: 8,
              backgroundColor: theme.colorScheme.surface,
              indicatorColor: theme.colorScheme.primaryContainer,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: l10n.get('nav_home'),
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: l10n.get('nav_transactions'),
                ),
                NavigationDestination(
                  icon: Icon(Icons.category_outlined),
                  selectedIcon: Icon(Icons.category),
                  label: l10n.get('nav_categories'),
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: l10n.get('nav_profile'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
