import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_tracker/core/localization/app_localizations.dart';

class EditProfileDialog extends StatefulWidget {
  final Function(File?)? onImageSelected;

  const EditProfileDialog({
    super.key,
    this.onImageSelected,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  File? _imageFile;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated && state.user != null) {
      _firstNameController.text = state.user!.firstName;
      _lastNameController.text = state.user!.lastName;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        widget.onImageSelected?.call(_imageFile);
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.get('image_pick_error')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProfileImage(
      String? imageUrl, String firstName, String lastName, ThemeData theme) {
    if (_imageFile != null) {
      return ClipOval(
        child: Image.file(
          _imageFile!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('data:image')) {
        // Handle base64 image
        try {
          final base64String = imageUrl.split(',')[1];
          final bytes = base64Decode(base64String);
          return ClipOval(
            child: Image.memory(
              bytes,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          );
        } catch (e) {
          return Center(
            child: Text(
              '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      } else {
        // Handle network image
        return ClipOval(
          child: Image.network(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        );
      }
    }
    // Fallback: initials
    return Center(
      child: Text(
        '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AuthBloc>().state;
    final currentUser = state is AuthAuthenticated ? state.user : null;
    final firstName = _firstNameController.text.isNotEmpty
        ? _firstNameController.text
        : currentUser?.firstName ?? '';
    final lastName = _lastNameController.text.isNotEmpty
        ? _lastNameController.text
        : currentUser?.lastName ?? '';

    return AlertDialog(
      title: Text(
        l10n.get('edit_profile'),
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.error != null) {
            // Log the error for debugging
            debugPrint('Profile Update Error: ${state.error}');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.get('profile_update_error')),
                    const SizedBox(height: 4),
                    Text(
                      state.error!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                action: SnackBarAction(
                  label: l10n.get('dismiss'),
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
          if (state.successMessage != null) {
            debugPrint('Profile Update Success: ${state.successMessage}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.of(context).pop();
          }
        },
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          final isLoading = state.isLoading;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (state.error != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.get('error'),
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            state.error!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Profile Picture
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: _buildProfileImage(
                              currentUser?.image, firstName, lastName, theme),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: l10n.get('first_name'),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('first_name_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: _lastNameController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: l10n.get('last_name'),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.get('last_name_required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),


                ],
              ),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: state.isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.get('cancel')),
        ),
        ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                          UpdateProfileEvent(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            profilePicture: _imageFile,
                          ),
                        );
                  }
                },
          child: state.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.get('save')),
        ),
      ],
    );
  }
}
