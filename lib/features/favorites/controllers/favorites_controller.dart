import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/app_snackbar.dart';
import 'package:google_contacts_app/core/utils/contact_list_refresh.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/usecases/get_favorites.dart';
import 'package:google_contacts_app/domain/usecases/toggle_favorite.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesController extends GetxController {
  FavoritesController({required GetFavorites getFavorites, required ToggleFavorite toggleFavorite})
    : _getFavorites = getFavorites,
      _toggleFavorite = toggleFavorite;

  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;

  final RxList<ContactEntity> contacts = <ContactEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading.value = true;
    final result = await _getFavorites();
    isLoading.value = false;

    switch (result) {
      case Success(data: final data):
        contacts.assignAll(data);
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  void onContactTap(ContactEntity contact) {
    Get.toNamed(AppRoutes.contactDetail, arguments: contact);
  }

  Future<void> onCall(ContactEntity contact) async {
    final phone = contact.phone;
    if (phone == null || phone.isEmpty) {
      AppSnackbar.error(AppStrings.T.error, AppStrings.T.noPhoneNumberAvailable);
      return;
    }

    await launchUrl(Uri(scheme: 'tel', path: phone));
  }

  Future<void> onRemoveFavorite(String id) async {
    final contact = contacts.firstWhereOrNull((item) => item.id == id);
    if (contact == null) {
      return;
    }

    final result = await _toggleFavorite(id, false);
    switch (result) {
      case Success():
        await HapticFeedback.mediumImpact();
        contacts.removeWhere((item) => item.id == id);
        syncFavoriteAcrossLists(contact: contact, isFavorite: false);
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }
}
