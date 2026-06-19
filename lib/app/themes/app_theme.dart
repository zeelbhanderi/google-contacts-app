import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_border_radius.dart';
import 'package:google_contacts_app/app/themes/app_colors.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onSurface,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onPrimary,
      secondaryContainer: Color(0xFFCEE5FF),
      onSecondaryContainer: AppColors.onSurface,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: AppColors.onPrimary,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      outline: Color(0xFF74777F),
      outlineVariant: Color(0xFFC4C6CF),
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarBackgroundColor: AppColors.surface,
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA8C7FA),
      onPrimary: Color(0xFF003258),
      primaryContainer: Color(0xFF004A77),
      onPrimaryContainer: Color(0xFFD3E3FD),
      secondary: Color(0xFF96CCFF),
      onSecondary: Color(0xFF003350),
      secondaryContainer: Color(0xFF004A77),
      onSecondaryContainer: Color(0xFFD3E3FD),
      surface: Color.fromARGB(255, 33, 35, 37),
      onSurface: Color(0xFFE2E2E6),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      outline: Color(0xFF8E9099),
      outlineVariant: Color(0xFF44474E),
    );

    return _buildTheme(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF1A1C1E),
      appBarBackgroundColor: const Color(0xFF1A1C1E),
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color appBarBackgroundColor,
  }) {
    final textTheme =
        TextTheme(
          displayLarge: AppTextStyles.displayLarge,
          headlineLarge: AppTextStyles.h1,
          headlineMedium: AppTextStyles.h2,
          headlineSmall: AppTextStyles.h3,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.labelLarge,
          labelSmall: AppTextStyles.labelSmall,
          titleLarge: AppTextStyles.appBarTitle,
        ).apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        );

    final buttonShape = AppBorderRadius.roundedRectangle();
    final inputBorder = AppBorderRadius.outlineInputBorder(colorScheme.outline);
    final focusedInputBorder = AppBorderRadius.outlineInputBorder(
      colorScheme.primary,
      width: 2,
    );
    final errorInputBorder = AppBorderRadius.outlineInputBorder(
      colorScheme.error,
    );
    final focusedErrorInputBorder = AppBorderRadius.outlineInputBorder(
      colorScheme.error,
      width: 2,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyles.buttonText,
          shape: buttonShape,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: AppTextStyles.buttonText,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: AppTextStyles.buttonText,
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: AppTextStyles.buttonText,
          shape: buttonShape,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: AppTextStyles.bodyMedium,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: focusedInputBorder,
        errorBorder: errorInputBorder,
        focusedErrorBorder: focusedErrorInputBorder,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? colorScheme.onSurface
              : colorScheme.outline;
          return AppTextStyles.labelSmall.copyWith(color: color);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? colorScheme.onSecondaryContainer
              : colorScheme.outline;
          return IconThemeData(color: color, size: 24);
        }),
      ),
    );
  }
}
