import 'package:get/get.dart';
import 'package:google_contacts_app/core/di/contact_di.dart';
import 'package:google_contacts_app/features/contact_form/controllers/contact_form_controller.dart';

class ContactFormBinding extends Bindings {
  @override
  void dependencies() {
    registerContactFormUseCases();
    Get.lazyPut(
      () => ContactFormController(
        addContact: Get.find(),
        updateContact: Get.find(),
      ),
    );
  }
}
