import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/features/auth/domain/services/biometric_service.dart';
import 'package:expense_tracker/features/main/presentation/pages/main_screen.dart';
import 'package:expense_tracker/features/auth/domain/entities/user.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiometricAuthScreen extends StatefulWidget {
  final User user;
  final String? token;

  const BiometricAuthScreen({
    Key? key,
    required this.user,
    this.token,
  }) : super(key: key);

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final _biometricService = BiometricService();
  String? _error;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    try {
      _isAuthenticating = true;
      final shouldUseBiometrics = await _biometricService.shouldUseBiometrics();
      if (!shouldUseBiometrics) {
        debugPrint('📱 Biometrics not enabled, proceeding with normal auth');
        _navigateToHome();
        return;
      }

      final isAuthenticated = await _biometricService.authenticate();
      if (isAuthenticated) {
        final authBloc = context.read<AuthBloc>();
        authBloc.add(AuthenticateWithBiometricsEvent(
          user: widget.user,
          token: widget.token,
        ));
      } else {
        debugPrint('❌ Biometric authentication failed');
        setState(() {
          _error = 'Authentication failed. Please try again.';
        });
      }
    } catch (e) {
      debugPrint('❌ Error during biometric authentication: $e');
      setState(() {
        _error = 'An error occurred during authentication. Please try again.';
      });
    } finally {
      _isAuthenticating = false;
    }
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _navigateToHome();
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Authenticating...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (_error != null) ...[
                const SizedBox(height: 20),
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.red,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _authenticate,
                  child: const Text('Try Again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
