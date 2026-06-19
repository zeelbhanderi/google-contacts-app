import 'package:get/get.dart';
import 'package:google_contacts_app/features/contacts/bindings/contacts_binding.dart';
import 'package:google_contacts_app/features/favorites/bindings/favorites_binding.dart';
import 'package:google_contacts_app/features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    ContactsBinding().dependencies();
    FavoritesBinding().dependencies();
    Get.lazyPut(HomeController.new);
  }
}
