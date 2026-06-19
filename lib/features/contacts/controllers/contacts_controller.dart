import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';
import 'package:google_contacts_app/app/themes/app_border_radius.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/app_snackbar.dart';
import 'package:google_contacts_app/core/utils/contact_list_refresh.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/usecases/add_contact.dart';
import 'package:google_contacts_app/domain/usecases/delete_contact.dart';
import 'package:google_contacts_app/domain/usecases/get_all_contacts.dart';
import 'package:google_contacts_app/domain/usecases/search_contacts.dart';
import 'package:google_contacts_app/domain/usecases/toggle_favorite.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ContactSection {
  const ContactSection({required this.letter, required this.contacts});

  final String letter;
  final List<ContactEntity> contacts;
}

class ContactsController extends GetxController {
  ContactsController({
    required GetAllContacts getAllContacts,
    required SearchContacts searchContacts,
    required DeleteContact deleteContact,
    required ToggleFavorite toggleFavorite,
    required AddContact addContact,
  }) : _getAllContacts = getAllContacts,
       _searchContacts = searchContacts,
       _deleteContact = deleteContact,
       _toggleFavorite = toggleFavorite,
       _addContact = addContact;

  final GetAllContacts _getAllContacts;
  final SearchContacts _searchContacts;
  final DeleteContact _deleteContact;
  final ToggleFavorite _toggleFavorite;
  final AddContact _addContact;

  final RxList<ContactEntity> contacts = <ContactEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  late final Worker _searchWorker;

  static const List<String> alphabet = ContactAlphabet.letters;

  @override
  void onInit() {
    super.onInit();
    _searchWorker = debounce(
      searchQuery,
      (_) => _performSearch(searchQuery.value),
      time: AppConstants.searchDebounce,
    );
    loadContacts();
  }

  @override
  void onClose() {
    _searchWorker.dispose();
    super.onClose();
  }

  List<ContactSection> get sections {
    final grouped = <String, List<ContactEntity>>{};
    for (final contact in contacts) {
      final letter = _sectionLetter(contact);
      grouped.putIfAbsent(letter, () => []).add(contact);
    }

    final letters = grouped.keys.toList()..sort();
    return letters
        .map(
          (letter) => ContactSection(
            letter: letter,
            contacts: grouped[letter]!
              ..sort((a, b) => a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase())),
          ),
        )
        .toList();
  }

  List<String> get availableLetters => sections.map((section) => section.letter).toList();

  int get flatItemCount {
    var count = 0;
    for (final section in sections) {
      count += 1 + section.contacts.length;
    }
    return count;
  }

  Object? itemAt(int index) {
    var current = 0;
    for (final section in sections) {
      if (current == index) {
        return section.letter;
      }
      current++;
      for (final contact in section.contacts) {
        if (current == index) {
          return contact;
        }
        current++;
      }
    }
    return null;
  }

  bool isFirstContactInSection(int index) {
    if (index <= 0) {
      return false;
    }
    return itemAt(index - 1) is String;
  }

  bool isLastContactInSection(int index) {
    if (index + 1 >= flatItemCount) {
      return true;
    }
    return itemAt(index + 1) is String;
  }

  BorderRadius contactTileBorderRadius(int index) {
    final radius = Radius.circular(AppBorderRadius.md);
    final isFirst = isFirstContactInSection(index);
    final isLast = isLastContactInSection(index);

    if (isFirst && isLast) {
      return BorderRadius.all(radius);
    }
    if (isFirst) {
      return BorderRadius.vertical(top: radius);
    }
    if (isLast) {
      return BorderRadius.vertical(bottom: radius);
    }
    return BorderRadius.zero;
  }

  int? indexForLetter(String letter) {
    var index = 0;
    for (final section in sections) {
      if (section.letter == letter) {
        return index;
      }
      index += 1 + section.contacts.length;
    }
    return null;
  }

  Future<void> loadContacts() async {
    isLoading.value = true;
    final result = await _getAllContacts();
    isLoading.value = false;

    switch (result) {
      case Success(data: final data):
        contacts.assignAll(data);
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  Future<void> onRefresh() => loadContacts();

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onContactTap(ContactEntity contact) {
    Get.toNamed(AppRoutes.contactDetail, arguments: contact);
  }

  void scrollToLetter(String letter) {
    final index = indexForLetter(letter);
    if (index == null) {
      return;
    }
    itemScrollController.scrollTo(
      index: index,
      duration: AppConstants.scrollAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  Future<void> onSwipeDelete(String id) async {
    final deletedContact = contacts.firstWhereOrNull((contact) => contact.id == id);
    if (deletedContact == null) {
      return;
    }

    final result = await _deleteContact(id);
    switch (result) {
      case Success():
        await HapticFeedback.mediumImpact();
        syncContactDeleted(id);
        AppSnackbar.success(
          AppStrings.T.contactDeleted,
          '${deletedContact.firstName} ${deletedContact.lastName}'.trim(),

          duration: AppConstants.undoSnackbarDuration,
        );
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  Future<void> onToggleFavorite(String id) async {
    final contact = contacts.firstWhereOrNull((item) => item.id == id);
    if (contact == null) {
      return;
    }

    final newValue = !contact.isFavorite;
    final result = await _toggleFavorite(id, newValue);
    switch (result) {
      case Success():
        await HapticFeedback.mediumImpact();
        final index = contacts.indexWhere((item) => item.id == id);
        if (index != -1) {
          final updatedContact = contact.copyWith(isFavorite: newValue);
          contacts[index] = updatedContact;
          syncFavoriteAcrossLists(contact: updatedContact, isFavorite: newValue);
        }
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  String _sectionLetter(ContactEntity contact) {
    final name = contact.firstName.trim();
    if (name.isEmpty) {
      return ContactAlphabet.other;
    }
    final char = name[0].toUpperCase();
    if (char.compareTo(ContactAlphabet.firstLetter) >= 0 &&
        char.compareTo(ContactAlphabet.lastLetter) <= 0) {
      return char;
    }
    return ContactAlphabet.other;
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      await loadContacts();
      return;
    }

    isLoading.value = true;
    final result = await _searchContacts(query.trim());
    isLoading.value = false;

    switch (result) {
      case Success(data: final data):
        contacts.assignAll(data);
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }
}
