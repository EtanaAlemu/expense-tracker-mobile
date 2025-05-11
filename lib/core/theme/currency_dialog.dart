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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        l10n.get('currency'),
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final currentCurrency = state.user?.currency ?? 'BIRR';

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCurrencyOption(
                context,
                'BIRR',
                l10n.get('currency_birr'),
                currentCurrency,
                '🇪🇹',
              ),
              _buildCurrencyOption(
                context,
                'USD',
                l10n.get('currency_usd'),
                currentCurrency,
                '🇺🇸',
              ),
              _buildCurrencyOption(
                context,
                'EUR',
                l10n.get('currency_eur'),
                currentCurrency,
                '🇪🇺',
              ),
              _buildCurrencyOption(
                context,
                'GBP',
                l10n.get('currency_gbp'),
                currentCurrency,
                '🇬🇧',
              ),
              _buildCurrencyOption(
                context,
                'JPY',
                l10n.get('currency_jpy'),
                currentCurrency,
                '🇯🇵',
              ),
              _buildCurrencyOption(
                context,
                'INR',
                l10n.get('currency_inr'),
                currentCurrency,
                '🇮🇳',
              ),
              _buildCurrencyOption(
                context,
                'CNY',
                l10n.get('currency_cny'),
                currentCurrency,
                '🇨🇳',
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.get('close')),
        ),
      ],
    );
  }

  Widget _buildCurrencyOption(
    BuildContext context,
    String code,
    String name,
    String currentCurrency,
    String flag,
  ) {
    final theme = Theme.of(context);
    final isSelected = code == currentCurrency;

    return ListTile(
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(code),
      subtitle: Text(name),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
            )
          : null,
      onTap: () {
        context.read<AuthBloc>().add(UpdateCurrencyEvent(code));
        Navigator.of(context).pop();
      },
    );
  }
}
