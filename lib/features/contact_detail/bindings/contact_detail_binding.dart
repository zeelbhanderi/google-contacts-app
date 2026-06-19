import 'package:get/get.dart';
import 'package:google_contacts_app/core/di/contact_di.dart';
import 'package:google_contacts_app/features/contact_detail/controllers/contact_detail_controller.dart';

class ContactDetailBinding extends Bindings {
  @override
  void dependencies() {
    registerContactDetailUseCases();
    Get.lazyPut(
      () => ContactDetailController(
        getContactById: Get.find(),
        deleteContact: Get.find(),
        toggleFavorite: Get.find(),
      ),
    );
  }
}
