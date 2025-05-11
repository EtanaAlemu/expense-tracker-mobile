import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // Add FocusNodes for each field
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();

    // Dispose FocusNodes
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
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
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
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
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    focusNode: _firstNameFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_lastNameFocus),
                    decoration: inputDecoration.copyWith(
                      labelText: l10n.get('first_name'),
                      hintText: l10n.get('enter_first_name'),
                      prefixIcon: Icon(Icons.person,
                          color: theme.iconTheme.color?.withOpacity(0.7)),
                      labelStyle:
                          TextStyle(color: theme.textTheme.bodyLarge?.color),
                      hintStyle:
                          TextStyle(color: theme.textTheme.bodySmall?.color),
                    ),
                    style: theme.textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('first_name_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_emailFocus),
                    decoration: inputDecoration.copyWith(
                      labelText: l10n.get('last_name'),
                      hintText: l10n.get('enter_last_name'),
                      prefixIcon: Icon(Icons.person,
                          color: theme.iconTheme.color?.withOpacity(0.7)),
                      labelStyle:
                          TextStyle(color: theme.textTheme.bodyLarge?.color),
                      hintStyle:
                          TextStyle(color: theme.textTheme.bodySmall?.color),
                    ),
                    style: theme.textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('last_name_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                    ),
                    style: theme.textTheme.bodyLarge,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('email_required');
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return l10n.get('invalid_email');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocus),
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
                      if (value.length < 6) {
                        return l10n.get('invalid_password');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (_formKey.currentState!.validate() && _acceptTerms) {
                        context.read<AuthBloc>().add(
                              SignUpEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                              ),
                            );
                      }
                    },
                    obscureText: _obscureConfirmPassword,
                    decoration: inputDecoration.copyWith(
                      labelText: l10n.get('confirm_password'),
                      hintText: l10n.get('enter_confirm_password'),
                      prefixIcon: Icon(Icons.lock,
                          color: theme.iconTheme.color?.withOpacity(0.7)),
                      labelStyle:
                          TextStyle(color: theme.textTheme.bodyLarge?.color),
                      hintStyle:
                          TextStyle(color: theme.textTheme.bodySmall?.color),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: theme.iconTheme.color?.withOpacity(0.7),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    style: theme.textTheme.bodyLarge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('confirm_password_required');
                      }
                      if (value != _passwordController.text) {
                        return l10n.get('passwords_dont_match');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          l10n.get('accept_terms'),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isLoading || !_acceptTerms
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      SignUpEvent(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                      ),
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator()
                          : Text(l10n.get('sign_up')),
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
