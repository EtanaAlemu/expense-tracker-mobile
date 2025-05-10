import 'package:expense_tracker_mobile/shared/dialog/confirm.modal.dart';
import 'package:expense_tracker_mobile/shared/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';

class ExportDialog {
  static void show(BuildContext context, Future<String> Function() export) {
    ConfirmModal.showConfirmDialog(
      context,
      title: "Are you sure?",
      content: const Text("Want to export all the data to a file"),
      onConfirm: () async {
        Navigator.of(context).pop(); // Close confirmation dialog

        LoadingModal.showLoadingDialog(
          context,
          content: const Text("Exporting data please wait"),
        );

        await export()
            .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("File has been saved in $value"),
                ),
              );
            })
            .catchError((err) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Something went wrong while exporting data",
                  ),
                ),
              );
            })
            .whenComplete(() {
              Navigator.of(context).pop(); // Close loading dialog
            });
      },
      onCancel: () {
        Navigator.of(context).pop(); // Close confirmation dialog
      },
    );
  }
}
