import 'package:get/get.dart';
import 'package:google_contacts_app/core/di/contact_di.dart';
import 'package:google_contacts_app/features/contacts/controllers/contacts_controller.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    registerContactsUseCases();
    Get.lazyPut(
      () => ContactsController(
        getAllContacts: Get.find(),
        searchContacts: Get.find(),
        deleteContact: Get.find(),
        toggleFavorite: Get.find(),
        addContact: Get.find(),
      ),
    );
  }
}
