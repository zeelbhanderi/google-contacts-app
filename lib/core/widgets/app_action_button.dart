import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';

enum AppActionButtonLayout { column, row }

class AppActionButton extends StatelessWidget {
  const AppActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.layout = AppActionButtonLayout.column,
    this.borderRadius,
    this.padding,
    this.iconSize,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppActionButtonLayout layout;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? (layout == AppActionButtonLayout.column ? Rs.dp(12) : Rs.dp(8));
    final resolvedIconSize =
        iconSize ?? (layout == AppActionButtonLayout.column ? Rs.dp(22) : Rs.dp(16));
    final resolvedPadding =
        padding ??
        (layout == AppActionButtonLayout.column
            ? EdgeInsets.symmetric(vertical: Rs.dp(14))
            : EdgeInsets.symmetric(horizontal: Rs.dp(12), vertical: Rs.dp(8)));

    return Material(
      color: colorScheme.primaryContainer.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: resolvedPadding,
          child: layout == AppActionButtonLayout.column
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: colorScheme.primary, size: resolvedIconSize),
                    SizedBox(height: Rs.dp(6)),
                    Text(
                      label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: resolvedIconSize, color: colorScheme.primary),
                    SizedBox(width: Rs.dp(6)),
                    Text(
                      label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
