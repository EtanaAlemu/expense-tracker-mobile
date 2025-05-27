import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            ChangePasswordEvent(
              currentPassword: _currentPasswordController.text,
              newPassword: _newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        l10n.get('change_password'),
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.error != current.error ||
            previous.successMessage != current.successMessage,
        listener: (context, state) {
          // Hide any existing snackbars
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
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
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            // Clear form fields
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
            // Close dialog after a short delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        },
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          final isLoading = state.isLoading;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  // Current Password
                  TextFormField(
                    controller: _currentPasswordController,
                    focusNode: _currentPasswordFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      _currentPasswordFocus.unfocus();
                      FocusScope.of(context).requestFocus(_newPasswordFocus);
                    },
                    obscureText: _obscureCurrentPassword,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: l10n.get('current_password'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _obscureCurrentPassword =
                                      !_obscureCurrentPassword;
                                });
                              },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('current_password_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // New Password
                  TextFormField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      _newPasswordFocus.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_confirmPasswordFocus);
                    },
                    obscureText: _obscureNewPassword,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: l10n.get('new_password'),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('new_password_required');
                      }
                      if (value.length < 6) {
                        return l10n.get('invalid_password');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm New Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _confirmPasswordFocus.unfocus();
                      _submitForm();
                    },
                    obscureText: _obscureConfirmPassword,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: l10n.get('confirm_new_password'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('confirm_password_required');
                      }
                      if (value != _newPasswordController.text) {
                        return l10n.get('passwords_dont_match');
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return TextButton(
              onPressed:
                  state.isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(l10n.get('cancel')),
            );
          },
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      _submitForm();
                    },
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(l10n.get('change_password')),
            );
          },
        ),
      ],
    );
  }
}
