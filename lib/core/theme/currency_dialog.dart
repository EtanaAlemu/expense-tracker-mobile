import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class CurrencyDialog extends StatelessWidget {
  const CurrencyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        } else if (state is AuthAuthenticated &&
            !state.isLoading &&
            state.error == null) {
          // Only close the dialog when the update is successful
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final currentUser = state is AuthAuthenticated ? state.user : null;
        final currentCurrency = currentUser?.currency ?? 'BIRR';
        final isLoading = state is AuthAuthenticated && state.isLoading;

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Container(
            width: screenWidth,
            constraints: BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Text(
                    l10n.get('currency_dialog_title'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildCurrencyOption(
                            context,
                            'BIRR',
                            '🇪🇹',
                            'Ethiopian Birr',
                            currentCurrency,
                            isLoading,
                          ),
                          _buildCurrencyOption(
                            context,
                            'USD',
                            '🇺🇸',
                            'US Dollar',
                            currentCurrency,
                            isLoading,
                          ),
                          _buildCurrencyOption(
                            context,
                            'EUR',
                            '🇪🇺',
                            'Euro',
                            currentCurrency,
                            isLoading,
                          ),
                          _buildCurrencyOption(
                            context,
                            'GBP',
                            '🇬🇧',
                            'British Pound',
                            currentCurrency,
                            isLoading,
                          ),
                          _buildCurrencyOption(
                            context,
                            'JPY',
                            '🇯🇵',
                            'Japanese Yen',
                            currentCurrency,
                            isLoading,
                          ),
                          _buildCurrencyOption(
                            context,
                            'INR',
                            '🇮🇳',
                            'Indian Rupee',
                            currentCurrency,
                            isLoading,
                          ),
                          _buildCurrencyOption(
                            context,
                            'CNY',
                            '🇨🇳',
                            'Chinese Yuan',
                            currentCurrency,
                            isLoading,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextButton(
                    onPressed:
                        isLoading ? null : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(l10n.get('close')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrencyOption(
    BuildContext context,
    String code,
    String flag,
    String name,
    String currentCurrency,
    bool isLoading,
  ) {
    final theme = Theme.of(context);
    final isSelected = code == currentCurrency;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(
        name,
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        code,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
            )
          : null,
      enabled: !isLoading,
      onTap: () {
        context.read<AuthBloc>().add(UpdateCurrencyEvent(code));
      },
    );
  }
}
