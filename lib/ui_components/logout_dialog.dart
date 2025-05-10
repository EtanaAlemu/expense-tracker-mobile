import 'package:expense_tracker_mobile/core/logic/app_cubit.dart';
import 'package:expense_tracker_mobile/shared/dialog/confirm.modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutDialog {
  static void show(BuildContext context) {
    ConfirmModal.showConfirmDialog(
      context,
      title: "Logout",
      content: const Text("Are you sure you want to logout?"),
      onConfirm: () async {
        Navigator.of(context).pop(); // Close dialog

        try {
          await context.read<AppCubit>().logout();

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Logged out successfully"),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/', (route) => false);
          }
        } catch (e) {
          debugPrint("Error during logout: $e");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error during logout. Please try again."),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}
