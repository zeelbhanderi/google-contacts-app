import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_button.dart';
import 'package:google_contacts_app/core/widgets/app_image_view.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.title,
    this.titleDescription,
    this.icon,
    this.description,
    this.child,
    this.primaryButtonLabel,
    this.content,
    this.primaryOnPressed,
    this.secondaryButtonLabel,
    this.secondaryOnPressed,
    this.titleActionButton,
  });

  final String? title;
  final Widget? titleDescription;
  final String? icon;
  final String? description;
  final Widget? child;
  final String? primaryButtonLabel;
  final String? secondaryButtonLabel;
  final Widget? content;
  final VoidCallback? primaryOnPressed;
  final VoidCallback? secondaryOnPressed;
  final Widget? titleActionButton;

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? titleDescription,
    String? icon,
    String? description,
    Widget? child,
    String? primaryButtonLabel,
    Widget? content,
    VoidCallback? primaryOnPressed,
    String? secondaryButtonLabel,
    VoidCallback? secondaryOnPressed,
    Widget? titleActionButton,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        title: title,
        titleDescription: titleDescription,
        icon: icon,
        description: description,
        primaryButtonLabel: primaryButtonLabel,
        content: content,
        primaryOnPressed: primaryOnPressed,
        secondaryButtonLabel: secondaryButtonLabel,
        secondaryOnPressed: secondaryOnPressed,
        titleActionButton: titleActionButton,
        child: child,
      ),
    );
  }

  static Future<bool> showConfirm({
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDismissible = false,
    String? icon,
  }) async {
    final context = Get.context;
    if (context == null) {
      return false;
    }

    final result = await show<bool>(
      context: context,
      title: title,
      icon: icon,
      description: message,
      primaryButtonLabel: confirmLabel ?? AppStrings.T.confirm,
      secondaryButtonLabel: cancelLabel ?? AppStrings.T.cancel,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      primaryOnPressed: () => Get.back(result: true),
      secondaryOnPressed: () => Get.back(result: false),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasButtons = primaryButtonLabel != null || secondaryButtonLabel != null;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(Rs.dp(12))),
            ),
            padding: EdgeInsets.symmetric(horizontal: Rs.dp(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: Rs.dp(16)),
                  if (title != null)
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          title!,
                          style: AppTextStyles.appBarTitle.copyWith(color: colorScheme.onSurface),
                        ),
                        const Spacer(),
                        if (titleActionButton != null) titleActionButton!,
                      ],
                    ),
                  if (titleDescription != null) titleDescription!,
                  if (title != null) ...[
                    SizedBox(height: Rs.dp(16)),
                    Divider(height: 0, color: colorScheme.outlineVariant),
                    SizedBox(height: Rs.dp(18)),
                  ],
                  if (content != null) ...[
                    Padding(
                      padding: EdgeInsets.only(bottom: Rs.dp(18)),
                      child: content,
                    ),
                  ] else ...[
                    if (icon != null)
                      Container(
                        width: Rs.dp(90),
                        height: Rs.dp(90),
                        margin: EdgeInsets.only(bottom: Rs.dp(20)),
                        padding: EdgeInsets.all(Rs.dp(20)),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(color: colorScheme.primary, width: Rs.dp(1.5)),
                        ),
                        child: AppImageView(imagePath: icon, fit: BoxFit.contain),
                      ),
                    if (description != null)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: Rs.dp(18),
                          left: Rs.dp(12),
                          right: Rs.dp(12),
                        ),
                        child: Text(
                          description!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (child != null) child!,
                  ],
                  if (hasButtons)
                    Row(
                      children: [
                        if (secondaryButtonLabel != null) ...[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: Rs.dp(20)),
                              child: AppButton(
                                text: secondaryButtonLabel!,
                                onPressed: secondaryOnPressed,
                                type: AppButtonType.secondary,
                              ),
                            ),
                          ),
                        ],
                        if (secondaryButtonLabel != null && primaryButtonLabel != null)
                          SizedBox(width: Rs.dp(14)),
                        if (primaryButtonLabel != null)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: Rs.dp(20)),
                              child: AppButton(
                                text: primaryButtonLabel!,
                                onPressed: primaryOnPressed,
                              ),
                            ),
                          ),
                      ],
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
