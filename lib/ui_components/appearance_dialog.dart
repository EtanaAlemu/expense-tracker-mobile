import 'package:expense_tracker_mobile/core/logic/app_cubit.dart';
import 'package:expense_tracker_mobile/core/utils/color.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppearanceDialog extends StatelessWidget {
  const AppearanceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text(
        "Appearance",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose a theme mode",
                style: theme.textTheme.bodyLarge!.apply(
                  color: ColorHelper.darken(theme.textTheme.bodyLarge!.color!),
                  fontWeightDelta: 1,
                ),
              ),
              const SizedBox(height: 15),
              ...ThemeMode.values.map((mode) {
                return RadioListTile<ThemeMode>(
                  title: Text(mode.name[0].toUpperCase() + mode.name.substring(1)),
                  value: mode,
                  groupValue: state.themeState.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      context.read<AppCubit>().updateThemeMode(value);
                    }
                  },
                );
              }),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
