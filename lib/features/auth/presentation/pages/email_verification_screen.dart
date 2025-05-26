import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isResending = false;
  bool _isVerifying = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _resendCode(String email) async {
    setState(() => _isResending = true);
    context.read<AuthBloc>().add(ResendVerificationCodeEvent(email: email));
  }

  void _verifyOtp(String otp, String email) {
    setState(() => _isVerifying = true);
    context.read<AuthBloc>().add(VerifyOtpEvent(otp: otp, email: email));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.get('verify_email_now')),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccess) {
            setState(() => _isVerifying = false);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.get('email_verification_success_title'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.get('email_verification_success_message'),
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.get('email_verification_success_submessage'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/auth',
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n.get('go_to_sign_in'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is OtpVerificationFailure) {
            setState(() => _isVerifying = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            _otpController.clear();
          } else if (state is ResendCodeSuccess) {
            setState(() => _isResending = false);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mark_email_unread_rounded,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.get('verification_code_sent_title'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.get('verification_code_sent_message'),
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.get('verification_code_sent_submessage'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            l10n.get('ok'),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ResendCodeFailure) {
            setState(() => _isResending = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mark_email_unread_rounded,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 24),
                    Text(
                      l10n.get('enter_the_6_digit_code'),
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _otpController,
                      onChanged: (value) {},
                      onCompleted: (value) => _verifyOtp(value, email),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 56,
                        fieldWidth: 40,
                        activeFillColor: theme.colorScheme.primaryContainer,
                        inactiveFillColor: theme.colorScheme.surface,
                        selectedFillColor: theme.colorScheme.primaryContainer,
                        activeColor: theme.colorScheme.primary,
                        selectedColor: theme.colorScheme.primary,
                        inactiveColor: theme.dividerColor,
                      ),
                      mainAxisAlignment: MainAxisAlignment.center,
                      enablePinAutofill: true,
                      autoDismissKeyboard: true,
                      textStyle: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isVerifying
                            ? null
                            : () {
                                final otp = _otpController.text;
                                if (otp.length == 6) {
                                  _verifyOtp(otp, email);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          l10n.get('enter_the_6_digit_code')),
                                      behavior: SnackBarBehavior.floating,
                                      margin: const EdgeInsets.all(16),
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
                        child: _isVerifying
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(l10n.get('verify_email_now')),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: _isResending || _isVerifying
                          ? null
                          : () => _resendCode(email),
                      icon: _isResending
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(l10n.get('resend_code')),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
