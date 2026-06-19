import 'package:get/get.dart';
import 'package:google_contacts_app/core/di/contact_di.dart';
import 'package:google_contacts_app/features/settings/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    registerSettingsUseCases();
    Get.lazyPut(
      () => SettingsController(
        getAllContacts: Get.find(),
        deleteContact: Get.find(),
      ),
    );
  }
}
