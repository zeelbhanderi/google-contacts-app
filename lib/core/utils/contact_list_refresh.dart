import 'package:get/get.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/features/contacts/controllers/contacts_controller.dart';
import 'package:google_contacts_app/features/favorites/controllers/favorites_controller.dart';

Future<void> refreshContactLists() async {
  if (Get.isRegistered<ContactsController>()) {
    final contactsController = Get.find<ContactsController>();
    contactsController.searchQuery.value = '';
    await contactsController.loadContacts();
  }
  if (Get.isRegistered<FavoritesController>()) {
    await Get.find<FavoritesController>().loadFavorites();
  }
}

void syncContactDeleted(String id) {
  if (Get.isRegistered<ContactsController>()) {
    Get.find<ContactsController>().contacts.removeWhere((item) => item.id == id);
  }
  if (Get.isRegistered<FavoritesController>()) {
    Get.find<FavoritesController>().contacts.removeWhere((item) => item.id == id);
  }
}

void syncFavoriteAcrossLists({
  required ContactEntity contact,
  required bool isFavorite,
}) {
  final updatedContact = contact.copyWith(isFavorite: isFavorite);
  _syncContactsFavorite(updatedContact);
  _syncFavoritesList(updatedContact, isFavorite);
}

void _syncContactsFavorite(ContactEntity contact) {
  if (!Get.isRegistered<ContactsController>()) {
    return;
  }

  final controller = Get.find<ContactsController>();
  final index = controller.contacts.indexWhere((item) => item.id == contact.id);
  if (index != -1) {
    controller.contacts[index] = contact;
  }
}

void _syncFavoritesList(ContactEntity contact, bool isFavorite) {
  if (!Get.isRegistered<FavoritesController>()) {
    return;
  }

  final controller = Get.find<FavoritesController>();
  if (isFavorite) {
    final index = controller.contacts.indexWhere((item) => item.id == contact.id);
    if (index == -1) {
      controller.contacts.add(contact);
      controller.contacts.sort(_compareContactsByName);
    } else {
      controller.contacts[index] = contact;
    }
    return;
  }

  controller.contacts.removeWhere((item) => item.id == contact.id);
}

int _compareContactsByName(ContactEntity a, ContactEntity b) {
  final nameA = '${a.firstName} ${a.lastName}'.trim().toLowerCase();
  final nameB = '${b.firstName} ${b.lastName}'.trim().toLowerCase();
  return nameA.compareTo(nameB);
}
