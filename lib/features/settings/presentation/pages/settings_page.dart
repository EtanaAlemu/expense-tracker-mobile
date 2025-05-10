import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/theme/appearance_dialog.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/pages/auth_screen.dart';
import 'package:expense_tracker/shared/widgets/confirm_dialog.dart';
import 'package:expense_tracker/shared/widgets/loading_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  ListTile _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        confirmLabel: 'Logout',
        cancelLabel: 'Cancel',
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(const SignOutEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildListTile(
            title: 'Appearance',
            icon: Icons.palette,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const AppearanceDialog(),
              );
            },
          ),
          _buildListTile(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
