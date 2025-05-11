import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/shared/widgets/app_button.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isResetSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            ForgotPasswordEvent(_emailController.text.trim()),
          );
      setState(() {
        _isResetSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('reset_password')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isResetSent
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.get('reset_link_sent'),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.get('reset_link_sent_message'),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(l10n.get('back_to_sign_in')),
                    ),
                  ],
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.get('forgot_password'),
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
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
                          if (!value.contains('@') || !value.contains('.')) {
                            return l10n.get('invalid_email');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return AppButton(
                            onPressed: state.isLoading ? null : _submitForm,
                            isLoading: state.isLoading,
                            child: Text(l10n.get('send_reset_link')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
