import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;

    return AlertDialog(
      title: Text(l10n.get('language')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (authState is AuthLoading)
            const CircularProgressIndicator()
          else
            ListTile(
              title: const Text('English'),
              trailing: authState is AuthAuthenticated &&
                      authState.user?.language == 'en'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                context.read<AuthBloc>().add(
                      const UpdateLanguageEvent('en'),
                    );
                Navigator.pop(context);
              },
            ),
          ListTile(
            title: const Text('አማርኛ'),
            trailing: authState is AuthAuthenticated &&
                    authState.user?.language == 'am'
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              context.read<AuthBloc>().add(
                    const UpdateLanguageEvent('am'),
                  );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.get('cancel')),
        ),
      ],
    );
  }
}
