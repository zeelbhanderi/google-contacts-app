import 'package:flutter/material.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => TextStyle(
        fontSize: Rs.sp(57),
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get h1 => TextStyle(
        fontSize: Rs.sp(28),
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
      );

  static TextStyle get h2 => TextStyle(
        fontSize: Rs.sp(24),
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.3,
      );

  static TextStyle get h3 => TextStyle(
        fontSize: Rs.sp(20),
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.35,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontSize: Rs.sp(16),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: Rs.sp(14),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: Rs.sp(12),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  static TextStyle get labelLarge => TextStyle(
        fontSize: Rs.sp(14),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelSmall => TextStyle(
        fontSize: Rs.sp(11),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  static TextStyle get contactName => TextStyle(
        fontSize: Rs.sp(16),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
      );

  static TextStyle get contactPhone => TextStyle(
        fontSize: Rs.sp(14),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get sectionHeader => TextStyle(
        fontSize: Rs.sp(12),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle get detailLabel => TextStyle(
        fontSize: Rs.sp(12),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        height: 1.33,
      );

  static TextStyle get detailValue => TextStyle(
        fontSize: Rs.sp(16),
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get avatarInitials => TextStyle(
        fontSize: Rs.sp(18),
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.2,
      );

  static TextStyle get appBarTitle => TextStyle(
        fontSize: Rs.sp(20),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.3,
      );

  static TextStyle get buttonText => TextStyle(
        fontSize: Rs.sp(16),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );
}
