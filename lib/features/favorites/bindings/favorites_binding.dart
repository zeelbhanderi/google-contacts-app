import 'package:get/get.dart';
import 'package:google_contacts_app/core/di/contact_di.dart';
import 'package:google_contacts_app/features/favorites/controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    registerFavoritesUseCases();
    Get.lazyPut(
      () => FavoritesController(
        getFavorites: Get.find(),
        toggleFavorite: Get.find(),
      ),
    );
  }
}
