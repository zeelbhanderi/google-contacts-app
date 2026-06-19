import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_image_view.dart';
import 'package:google_contacts_app/gen/assets.gen.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(Rs.dp(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImageView(imagePath: Assets.images.noDataFound.path, height: Rs.dp(100)),
            SizedBox(height: Rs.dp(16)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(color: colorScheme.onSurface),
            ),
            SizedBox(height: Rs.dp(8)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            if (onAction != null && actionLabel != null) ...[
              SizedBox(height: Rs.dp(24)),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!, style: AppTextStyles.buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
