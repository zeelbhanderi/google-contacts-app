import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/app_snackbar.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_image_view.dart';
import 'package:google_contacts_app/features/auth/controllers/auth_controller.dart';
import 'package:google_contacts_app/features/auth/views/widgets/google_sign_in_button.dart';
import 'package:google_contacts_app/gen/assets.gen.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                AppImageView(
                  imagePath: Assets.images.appLogo.path,
                  width: Rs.dp(96),
                  height: Rs.dp(96),
                ),
                SizedBox(height: Rs.dp(24)),
                Text(
                  AppStrings.T.appName,
                  style: AppTextStyles.h1.copyWith(color: colorScheme.onSurface),
                ),
                SizedBox(height: Rs.dp(8)),
                Text(
                  AppStrings.T.signInSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const Spacer(),
                if (controller.isSyncing.value) ...[
                  const CircularProgressIndicator(),
                  SizedBox(height: Rs.dp(16)),
                  Text(controller.syncMessage.value, style: AppTextStyles.bodyMedium),
                  SizedBox(height: Rs.dp(24)),
                ],
                GoogleSignInButton(
                  onPressed: controller.isLoading.value || controller.isSyncing.value
                      ? null
                      : _onSignIn,
                  isLoading: controller.isLoading.value,
                ),
                SizedBox(height: Rs.dp(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSignIn() async {
    final result = await controller.signInWithGoogle();
    switch (result) {
      case Success():
        if (controller.firebaseUser.value != null) {
          await Get.offAllNamed(AppRoutes.home);
        }
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.signInFailed, message);
    }
  }
}
