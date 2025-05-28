import 'package:flutter/material.dart';

enum AppButtonVariant {
  filled,
  outlined,
  text,
}

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final bool isFullWidth;
  final AppButtonVariant variant;
  final Widget child;

  const AppButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.filled,
    required this.child,
  });

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;

    switch (variant) {
      case AppButtonVariant.filled:
        return ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: theme.colorScheme.onPrimary,
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case AppButtonVariant.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case AppButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : child;

    Widget button;
    switch (variant) {
      case AppButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getButtonStyle(context),
          child: buttonChild,
        );
        break;
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getButtonStyle(context),
          child: buttonChild,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _getButtonStyle(context),
          child: buttonChild,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
