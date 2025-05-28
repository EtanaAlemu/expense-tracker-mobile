import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/shared/widgets/app_button.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? token;

  const ResetPasswordScreen({
    super.key,
    this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isResetSent = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.token != null) {
        // Reset password with token
        context.read<AuthBloc>().add(
              ResetPasswordEvent(
                token: widget.token!,
                newPassword: _passwordController.text.trim(),
              ),
            );
      } else {
        // Request password reset
        context.read<AuthBloc>().add(
              ForgotPasswordEvent(_emailController.text.trim()),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('reset_password')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                previous.error != current.error ||
                previous.successMessage != current.successMessage,
            listener: (context, state) {
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
                setState(() {
                  _isResetSent = true;
                });
              }
            },
            builder: (context, state) {
              return _isResetSent
                  ? Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 64,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                widget.token != null
                                    ? l10n.get('password_reset_success')
                                    : l10n.get('reset_link_sent'),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.token != null
                                    ? l10n.get('password_changed')
                                    : l10n.get('reset_link_sent_message'),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: 200,
                                child: AppButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      '/auth',
                                      (route) => false,
                                    );
                                  },
                                  isFullWidth: false,
                                  child: Center(
                                    child: Text(l10n.get('back_to_sign_in')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              widget.token != null
                                  ? l10n.get('enter_new_password')
                                  : l10n.get('forgot_password'),
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            if (widget.token == null) ...[
                              Text(
                                l10n.get('forgot_password_message'),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: l10n.get('email'),
                                  hintText: l10n.get('enter_email'),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.get('required_field');
                                  }
                                  if (!value.contains('@') ||
                                      !value.contains('.')) {
                                    return l10n.get('invalid_email');
                                  }
                                  return null;
                                },
                              ),
                            ] else ...[
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: l10n.get('new_password'),
                                  hintText: l10n.get('enter_new_password'),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.get('required_field');
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
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: l10n.get('confirm_new_password'),
                                  hintText: l10n.get('confirm_new_password'),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.get('required_field');
                                  }
                                  if (value != _passwordController.text) {
                                    return l10n.get('passwords_dont_match');
                                  }
                                  return null;
                                },
                              ),
                            ],
                            const SizedBox(height: 24),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: AppButton(
                                    onPressed:
                                        state.isLoading ? null : _submitForm,
                                    isLoading: state.isLoading,
                                    child: Text(
                                      widget.token != null
                                          ? l10n.get('reset_password')
                                          : l10n.get('send_reset_link'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
