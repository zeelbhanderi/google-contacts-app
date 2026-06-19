import 'package:flutter/widgets.dart';

class Rs {
  Rs._();

  static const double _baseWidth = 375;
  static double _scaleFactor = 1;

  static void initFromView() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    _updateScaleFactor(MediaQueryData.fromView(view).size.width);
  }

  static void init(BuildContext context) {
    _updateScaleFactor(MediaQuery.sizeOf(context).width);
  }

  static void _updateScaleFactor(double width) {
    final clampedWidth = width.clamp(320.0, 430.0);
    _scaleFactor = clampedWidth / _baseWidth;
  }

  static double sp(double size) {
    return (size * _scaleFactor).clamp(size * 0.85, size * 1.15);
  }

  static double dp(double size) {
    return (size * _scaleFactor).clamp(size * 0.85, size * 1.15);
  }
}
