import 'package:expense_tracker_mobile/core/logic/app_cubit.dart';
import 'package:expense_tracker_mobile/core/utils/color.helper.dart';
import 'package:expense_tracker_mobile/shared/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.read<AppCubit>().state;

    final TextEditingController firstNameController =
        TextEditingController(text: state.authState.user?.firstName ?? '');
    final TextEditingController lastNameController =
        TextEditingController(text: state.authState.user?.lastName ?? '');
    final TextEditingController emailController =
        TextEditingController(text: state.authState.user?.email ?? '');

    return AlertDialog(
      title: const Text(
        "Profile",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update your profile information",
              style: theme.textTheme.bodyLarge!.apply(
                color: ColorHelper.darken(theme.textTheme.bodyLarge!.color!),
                fontWeightDelta: 1,
              ),
            ),
            const SizedBox(height: 15),
            _buildTextField("First Name", firstNameController),
            const SizedBox(height: 15),
            _buildTextField("Last Name", lastNameController),
            const SizedBox(height: 15),
            _buildTextField("Email", emailController, TextInputType.emailAddress),
          ],
        ),
      ),
      actions: [
        BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return AppButton(
              onPressed: state.profileState.isLoading
                  ? null
                  : () async {
                      try {
                        await context.read<AppCubit>().updateProfile(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                            );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profile updated successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (_) {}
                    },
              height: 45,
              label: state.profileState.isLoading ? "Saving..." : "Save",
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, [
    TextInputType inputType = TextInputType.text,
  ]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter your $label".toLowerCase(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      ),
    );
  }
}
