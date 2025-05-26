import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/main/presentation/pages/main_screen.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Add FocusNodes for each field
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    // Dispose FocusNodes
    _emailFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  void _showForgotPasswordDialog(BuildContext context, ThemeData theme) {
    final TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthError &&
                state.error != null &&
                state.error!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AuthSuccess) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    l10n.get('password_reset_sent'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    l10n.get('password_reset_sent_message'),
                    style: theme.textTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(l10n.get('close')),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.email),
                      label: Text(l10n.get('open_email_app')),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _launchEmail(emailController.text);
                      },
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: Text(
                l10n.get('forgot_password'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.get('forgot_password_message'),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: l10n.get('email'),
                          hintText: l10n.get('enter_email'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.get('email_required');
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return l10n.get('invalid_email');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.get('cancel')),
                ),
                ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  ForgotPasswordEvent(emailController.text),
                                );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(l10n.get('send_reset_link')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to launch email with optional recipient
  Future<void> _launchEmail([String? recipientEmail]) async {
    debugPrint('Attempting to open email app inbox' +
        (recipientEmail != null ? ' for $recipientEmail' : ''));

    try {
      if (Platform.isIOS) {
        final uri = Uri.parse('message://');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
        } else {
          if (mounted) _showManualInstructions(context);
        }
      } else if (Platform.isAndroid) {
        final intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.APP_EMAIL',
          flags: [0x10000000],
        );
        await intent.launch();
      } else {
        debugPrint('Unsupported platform');
      }
    } catch (e) {
      debugPrint('Error launching email app: $e');
      if (mounted) _showManualInstructions(context);
    }
  }

  // Show manual instructions as fallback
  void _showManualInstructions(BuildContext context) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Could not open email app. Please check your email manually.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: isDark ? theme.cardColor.withOpacity(0.2) : theme.cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.error != current.error ||
          previous.isLoading != current.isLoading ||
          previous.isAuthenticated != current.isAuthenticated,
      listener: (context, state) {
        if (!mounted) return;

        if (state.error != null) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.clearSnackBars();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              action: SnackBarAction(
                label: l10n.get('dismiss'),
                textColor: Colors.white,
                onPressed: () {
                  if (mounted) {
                    scaffoldMessenger.hideCurrentSnackBar();
                  }
                },
              ),
            ),
          );
        }

        if (state.isAuthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        }
      },
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                    decoration: inputDecoration.copyWith(
                      labelText: l10n.get('email'),
                      hintText: l10n.get('enter_email'),
                      prefixIcon: Icon(Icons.email,
                          color: theme.iconTheme.color?.withOpacity(0.7)),
                      labelStyle:
                          TextStyle(color: theme.textTheme.bodyLarge?.color),
                      hintStyle:
                          TextStyle(color: theme.textTheme.bodySmall?.color),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    style: theme.textTheme.bodyLarge,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('email_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(SignInEvent(
                              email: _emailController.text,
                              password: _passwordController.text,
                              rememberMe: _rememberMe,
                            ));
                      }
                    },
                    obscureText: _obscurePassword,
                    decoration: inputDecoration.copyWith(
                      labelText: l10n.get('password'),
                      hintText: l10n.get('enter_password'),
                      prefixIcon: Icon(Icons.lock,
                          color: theme.iconTheme.color?.withOpacity(0.7)),
                      labelStyle:
                          TextStyle(color: theme.textTheme.bodyLarge?.color),
                      hintStyle:
                          TextStyle(color: theme.textTheme.bodySmall?.color),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: theme.iconTheme.color?.withOpacity(0.7),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: theme.textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('password_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Remember me checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(
                        l10n.get('remember_me'),
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          _showForgotPasswordDialog(context, theme);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          l10n.get('forgot_password'),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Sign in button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      SignInEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        rememberMe: _rememberMe,
                                      ),
                                    );
                              }
                            },
                      
                      child: state.isLoading
                          ? const CircularProgressIndicator()
                          : Text(l10n.get('sign_in')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
