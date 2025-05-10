import 'package:expense_tracker_mobile/shared/dialog/confirm.modal.dart';
import 'package:expense_tracker_mobile/shared/dialog/loading_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportDialog {
  static Future<void> show(
    BuildContext context,
    Future<void> Function(String path) import,
  ) async {
    try {
      final pick = await FilePicker.platform.pickFiles(
        dialogTitle: "Pick file",
        allowMultiple: false,
        allowCompression: false,
        type: FileType.custom,
        allowedExtensions: ["json"],
      );

      if (pick == null || pick.files.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please select a file")));
        return;
      }

      final PlatformFile file = pick.files.first;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a file")));

      ConfirmModal.showConfirmDialog(
        context,
        title: "Are you sure?",
        content: const Text(
          "All payment data, categories, and accounts will be erased and replaced with the information imported from the backup.",
        ),
        onConfirm: () async {
          Navigator.of(context).pop(); // Close confirm

          LoadingModal.showLoadingDialog(
            context,
            content: const Text("Importing data, please wait..."),
          );

          try {
            await import(file.path!);

            if (context.mounted) {
              Navigator.of(context).pop(); // Close loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Successfully imported.")),
              );
            }
          } catch (err) {
            Navigator.of(context).pop(); // Close loading
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Something went wrong while importing data"),
              ),
            );
          }
        },
        onCancel: () {
          Navigator.of(context).pop(); // Close confirm
        },
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong while importing data"),
        ),
      );
    }
  }
}
