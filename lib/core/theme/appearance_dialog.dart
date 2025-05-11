import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/presentation/bloc/theme_bloc.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class AppearanceDialog extends StatelessWidget {
  const AppearanceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        l10n.get('appearance'),
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: Text(l10n.get('system_theme')),
                value: ThemeMode.system,
                groupValue:
                    state is ThemeLoaded ? state.themeMode : ThemeMode.system,
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<ThemeBloc>()
                        .add(ThemeToggled(themeMode: value));
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.get('light_theme')),
                value: ThemeMode.light,
                groupValue:
                    state is ThemeLoaded ? state.themeMode : ThemeMode.system,
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<ThemeBloc>()
                        .add(ThemeToggled(themeMode: value));
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.get('dark_theme')),
                value: ThemeMode.dark,
                groupValue:
                    state is ThemeLoaded ? state.themeMode : ThemeMode.system,
                onChanged: (value) {
                  if (value != null) {
                    context
                        .read<ThemeBloc>()
                        .add(ThemeToggled(themeMode: value));
                  }
                },
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
}
