import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_colors.dart';

class AvatarHelper {
  AvatarHelper._();

  static int _paletteIndex(String fullName, int paletteLength) {
    return fullName.hashCode.abs() % paletteLength;
  }

  /// Bold background for [AppAvatarStyle.filled] avatars (white initials on top).
  static Color filledBackgroundFromName(String fullName) {
    final index = _paletteIndex(fullName, AppColors.avatarPastelForegroundColors.length);
    return AppColors.avatarPastelForegroundColors[index];
  }

  /// Soft background for [AppAvatarStyle.pastel] avatars.
  static Color pastelBackgroundFromName(String fullName) {
    final index = _paletteIndex(fullName, AppColors.avatarPastelColors.length);
    return AppColors.avatarPastelColors[index];
  }

  /// Text color for [AppAvatarStyle.pastel] avatars.
  static Color pastelForegroundFromName(String fullName) {
    final index = _paletteIndex(fullName, AppColors.avatarPastelForegroundColors.length);
    return AppColors.avatarPastelForegroundColors[index];
  }

  static String initialsFromName(String firstName, String lastName) {
    if (firstName.isEmpty) {
      return '?';
    }
    final firstInitial = firstName[0].toUpperCase();
    if (lastName.isEmpty) {
      return firstInitial;
    }
    return '$firstInitial${lastName[0].toUpperCase()}';
  }
}
