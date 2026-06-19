import 'package:flutter/material.dart';
import 'package:google_contacts_app/app/themes/app_border_radius.dart';
import 'package:google_contacts_app/app/themes/app_colors.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_image_view.dart';
import 'package:google_contacts_app/gen/assets.gen.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onPressed, this.isLoading = false});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.googleSignInDarkBackground
        : AppColors.googleSignInLightBackground;
    final foregroundColor = isDark
        ? AppColors.googleSignInDarkForeground
        : AppColors.googleSignInLightForeground;
    final borderSide = isDark
        ? BorderSide(color: AppColors.googleSignInDarkBorder, width: Rs.dp(1))
        : BorderSide.none;
    final buttonShape = AppBorderRadius.roundedRectangle(side: borderSide);
    final isEnabled = onPressed != null && !isLoading;
    final logoSize = Rs.dp(20);

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: isLoading ? AppStrings.T.signingIn : AppStrings.T.signInWithGoogle,
      child: SizedBox(
        height: Rs.dp(48),
        child: Material(
          color: backgroundColor.withValues(alpha: isEnabled ? 1 : 0.5),
          shape: buttonShape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: AppBorderRadius.allSm,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: logoSize,
                      height: logoSize,
                      child: CircularProgressIndicator(strokeWidth: 2, color: foregroundColor),
                    )
                  else
                    AppImageView(
                      imagePath: Assets.images.googleSignin,
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                    ),

                  SizedBox(width: Rs.dp(16)),
                  Text(
                    isLoading ? AppStrings.T.signingIn : AppStrings.T.signInWithGoogle,
                    style: AppTextStyles.buttonText.copyWith(color: foregroundColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
