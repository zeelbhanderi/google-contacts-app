import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_border_radius.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';

enum AppButtonType { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shape = AppBorderRadius.roundedRectangle();
    final minimumSize = Size(double.infinity, Rs.dp(48));
    final textStyle = AppTextStyles.buttonText.copyWith(
      color: type == AppButtonType.primary ? colorScheme.onPrimary : colorScheme.primary,
    );

    if (type == AppButtonType.secondary) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: minimumSize,
          shape: shape,
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.primary,
          textStyle: textStyle,
        ),
        child: Text(text),
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: minimumSize,
        shape: shape,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: textStyle,
      ),
      child: Text(text),
    );
  }
}
