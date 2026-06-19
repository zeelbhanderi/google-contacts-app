import 'package:get/get.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final RxInt currentTab = HomeTabIndex.contacts.obs;

  void changeTab(int index) {
    currentTab.value = index;
  }

  void openAddContact() {
    Get.toNamed(AppRoutes.contactForm);
  }

  void openSettings() {
    Get.toNamed(AppRoutes.settings);
  }
}
