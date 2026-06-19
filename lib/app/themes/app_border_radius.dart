import 'package:flutter/material.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';

class AppBorderRadius {
  AppBorderRadius._();

  static double get sm => Rs.dp(6);

  static double get md => Rs.dp(14);

  static BorderRadius get allSm => BorderRadius.circular(sm);

  static BorderRadius get allMd => BorderRadius.circular(md);

  static RoundedRectangleBorder roundedRectangle({BorderSide side = BorderSide.none}) {
    return RoundedRectangleBorder(borderRadius: allSm, side: side);
  }

  static OutlineInputBorder outlineInputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: allSm,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
