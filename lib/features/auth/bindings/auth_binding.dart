import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/core/di/contact_di.dart';
import 'package:google_contacts_app/domain/repositories/i_contact_repository.dart';
import 'package:google_contacts_app/domain/usecases/clear_all_local_contacts.dart';
import 'package:google_contacts_app/domain/usecases/sync_remote_contacts_to_local.dart';
import 'package:google_contacts_app/features/auth/controllers/auth_controller.dart';
import 'package:google_contacts_app/features/auth/controllers/auth_gate_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    registerContactDependencies();

    if (!Get.isRegistered<GoogleSignIn>()) {
      Get.lazyPut(GoogleSignIn.new, fenix: true);
    }

    Get.lazyPut(() => SyncRemoteContactsToLocal(Get.find<IContactRepository>()));
    Get.lazyPut(() => ClearAllLocalContacts(Get.find<IContactRepository>()));

    if (!Get.isRegistered<AuthController>()) {
      Get.put(
        AuthController(
          googleSignIn: Get.find<GoogleSignIn>(),
          firebaseAuth: FirebaseAuth.instance,
          syncRemoteContactsToLocal: Get.find<SyncRemoteContactsToLocal>(),
          clearAllLocalContacts: Get.find<ClearAllLocalContacts>(),
        ),
        permanent: true,
      );
    }
  }
}

class AuthGateBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    Get.put(
      AuthGateController(authController: Get.find<AuthController>()),
    );
  }
}
