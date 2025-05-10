import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';

class CurrencyDialog extends StatelessWidget {
  const CurrencyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Currency',
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
                'Ethiopian Birr',
                currentCurrency,
                '🇪🇹',
              ),
              _buildCurrencyOption(
                context,
                'USD',
                'US Dollar',
                currentCurrency,
                '🇺🇸',
              ),
              _buildCurrencyOption(
                context,
                'EUR',
                'Euro',
                currentCurrency,
                '🇪🇺',
              ),
              _buildCurrencyOption(
                context,
                'GBP',
                'British Pound',
                currentCurrency,
                '🇬🇧',
              ),
              _buildCurrencyOption(
                context,
                'JPY',
                'Japanese Yen',
                currentCurrency,
                '🇯🇵',
              ),
              _buildCurrencyOption(
                context,
                'INR',
                'Indian Rupee',
                currentCurrency,
                '🇮🇳',
              ),
              _buildCurrencyOption(
                context,
                'CNY',
                'Chinese Yuan',
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
          child: const Text('Close'),
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
