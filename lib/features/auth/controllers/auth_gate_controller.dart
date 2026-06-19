import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/app_snackbar.dart';
import 'package:google_contacts_app/features/auth/controllers/auth_controller.dart';

class AuthGateController extends GetxController {
  AuthGateController({required AuthController authController})
      : _authController = authController;

  final AuthController _authController;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final user = FirebaseAuth.instance.currentUser ??
          await FirebaseAuth.instance.authStateChanges().first;

      if (user == null) {
        _goToSignIn();
        return;
      }

      _authController.checkInitialAuthState();

      final result = await _authController.syncContactsAfterAuth();
      switch (result) {
        case Success():
          _goToHome();
        case Failure(message: final message):
          AppSnackbar.error(AppStrings.T.syncFailed, message);
          _goToHome();
      }
    } catch (_) {
      if (FirebaseAuth.instance.currentUser == null) {
        _goToSignIn();
        return;
      }
      _goToHome();
    }
  }

  void _goToHome() {
    if (Get.currentRoute != AppRoutes.home) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  void _goToSignIn() {
    if (Get.currentRoute != AppRoutes.signIn) {
      Get.offAllNamed(AppRoutes.signIn);
    }
  }
}
