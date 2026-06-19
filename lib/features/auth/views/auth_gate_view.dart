import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/features/auth/controllers/auth_controller.dart';
import 'package:google_contacts_app/features/auth/controllers/auth_gate_controller.dart';

class AuthGateView extends GetView<AuthGateController> {
  const AuthGateView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: Rs.dp(16)),
              Text(
                authController.syncMessage.value.isEmpty
                    ? AppStrings.T.loading
                    : authController.syncMessage.value,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
