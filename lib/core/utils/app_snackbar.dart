import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_border_radius.dart';
import 'package:google_contacts_app/app/themes/app_colors.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';

enum AppSnackbarType { error, success, info, warning }

class AppSnackbar {
  AppSnackbar._();

  static const _defaultDuration = Duration(seconds: 3);
  static const _margin = EdgeInsets.all(16);

  static void show(
    String title,
    String message, {
    AppSnackbarType type = AppSnackbarType.info,
    Duration? duration,
    TextButton? mainButton,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    bool isDismissible = true,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    final colors = _resolveColors(
      type: type,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );

    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      backgroundColor: colors.background,
      colorText: colors.foreground,
      margin: _margin,
      borderRadius: AppBorderRadius.md,
      duration: duration ?? _defaultDuration,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
      mainButton: mainButton,
      snackStyle: SnackStyle.FLOATING,
      titleText: Text(title, style: AppTextStyles.labelLarge.copyWith(color: colors.foreground)),
      messageText: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: colors.foreground),
      ),
    );
  }

  static void error(String title, String message, {Duration? duration, TextButton? mainButton}) {
    show(title, message, type: AppSnackbarType.error, duration: duration, mainButton: mainButton);
  }

  static void success(String title, String message, {Duration? duration, TextButton? mainButton}) {
    show(title, message, type: AppSnackbarType.success, duration: duration, mainButton: mainButton);
  }

  static void info(String title, String message, {Duration? duration, TextButton? mainButton}) {
    show(title, message, duration: duration, mainButton: mainButton);
  }

  static void warning(String title, String message, {Duration? duration, TextButton? mainButton}) {
    show(title, message, type: AppSnackbarType.warning, duration: duration, mainButton: mainButton);
  }

  static _SnackbarColors _resolveColors({
    required AppSnackbarType type,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    if (backgroundColor != null && foregroundColor != null) {
      return _SnackbarColors(background: backgroundColor, foreground: foregroundColor);
    }

    final scheme = Get.theme.colorScheme;
    switch (type) {
      case AppSnackbarType.error:
        return _SnackbarColors(
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
        );
      case AppSnackbarType.success:
        return const _SnackbarColors(
          background: AppColors.successBackground,
          foreground: AppColors.success,
        );
      case AppSnackbarType.warning:
        final isDark = scheme.brightness == Brightness.dark;
        return _SnackbarColors(
          background: isDark ? const Color(0xFF4E342E) : const Color(0xFFFFF3E0),
          foreground: isDark ? const Color(0xFFFFCC80) : const Color(0xFFE65100),
        );
      case AppSnackbarType.info:
        return _SnackbarColors(
          background: scheme.inverseSurface,
          foreground: scheme.onInverseSurface,
        );
    }
  }
}

class _SnackbarColors {
  const _SnackbarColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
