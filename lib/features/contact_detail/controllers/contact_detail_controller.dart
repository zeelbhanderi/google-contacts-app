import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/routes/app_routes.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/app_snackbar.dart';
import 'package:google_contacts_app/core/utils/contact_list_refresh.dart';
import 'package:google_contacts_app/core/widgets/custom_bottom_sheet.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/usecases/delete_contact.dart';
import 'package:google_contacts_app/domain/usecases/get_contact_by_id.dart';
import 'package:google_contacts_app/domain/usecases/toggle_favorite.dart';
import 'package:google_contacts_app/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailController extends GetxController {
  ContactDetailController({
    required GetContactById getContactById,
    required DeleteContact deleteContact,
    required ToggleFavorite toggleFavorite,
  }) : _getContactById = getContactById,
       _deleteContact = deleteContact,
       _toggleFavorite = toggleFavorite;

  final GetContactById _getContactById;
  final DeleteContact _deleteContact;
  final ToggleFavorite _toggleFavorite;

  final Rx<ContactEntity> contact = ContactEntity(
    id: '',
    firstName: '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
  ).obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final argument = Get.arguments;
    if (argument is ContactEntity) {
      contact.value = argument;
      return;
    }

    final contactId = Get.parameters['id'];
    if (contactId != null && contactId.isNotEmpty) {
      loadContact(contactId);
    }
  }

  Future<void> loadContact(String id) async {
    isLoading.value = true;
    final result = await _getContactById(id);
    isLoading.value = false;

    switch (result) {
      case Success(data: final data):
        contact.value = data;
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  String get displayName => '${contact.value.firstName} ${contact.value.lastName}'.trim();

  Future<void> onEmail() async {
    final email = contact.value.email;
    if (email == null || email.isEmpty) {
      AppSnackbar.error(AppStrings.T.error, AppStrings.T.noEmailAddressAvailable);
      return;
    }

    await _launchUri(Uri(scheme: 'mailto', path: email));
  }

  Future<void> onCall() async {
    final phone = contact.value.phone;
    if (phone == null || phone.isEmpty) {
      AppSnackbar.error(AppStrings.T.error, AppStrings.T.noPhoneNumberAvailable);
      return;
    }

    await _launchUri(Uri(scheme: 'tel', path: phone));
  }

  Future<void> onSms() async {
    final phone = contact.value.phone;
    if (phone == null || phone.isEmpty) {
      AppSnackbar.error(AppStrings.T.error, AppStrings.T.noPhoneNumberAvailable);
      return;
    }

    await _launchUri(Uri(scheme: 'sms', path: phone));
  }

  Future<void> onEdit() async {
    final result = await Get.toNamed(AppRoutes.contactForm, arguments: contact.value);
    if (result is ContactEntity) {
      contact.value = result;
    }
  }

  Future<void> onToggleFavorite() async {
    final current = contact.value;
    final newValue = !current.isFavorite;
    final result = await _toggleFavorite(current.id, newValue);

    switch (result) {
      case Success():
        await HapticFeedback.mediumImpact();
        final updatedContact = current.copyWith(isFavorite: newValue);
        contact.value = updatedContact;
        syncFavoriteAcrossLists(contact: updatedContact, isFavorite: newValue);
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  Future<void> onConfirmDelete() async {
    final confirmed = await AppBottomSheet.showConfirm(
      title: AppStrings.T.deleteContact,
      icon: Assets.icons.icDelete,
      message: AppStrings.T.deleteContactMessage(displayName),
    );
    if (!confirmed) {
      return;
    }
    await onDeleteContact();
  }

  Future<void> onDeleteContact() async {
    final result = await _deleteContact(contact.value.id);
    switch (result) {
      case Success():
        await HapticFeedback.mediumImpact();
        syncContactDeleted(contact.value.id);
        Get.back(result: true);
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  Future<void> copyPhone(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    AppSnackbar.success(AppStrings.T.copied, AppStrings.T.phoneNumberCopied);
  }

  Future<void> copyEmail(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    AppSnackbar.success(AppStrings.T.copied, AppStrings.T.emailCopied);
  }

  Future<void> openWebsite(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    await _launchUri(uri);
  }

  Future<void> _launchUri(Uri uri) async {
    final launched = await launchUrl(uri);
    if (!launched) {
      AppSnackbar.error(AppStrings.T.error, AppStrings.T.couldNotOpenUri(uri.toString()));
    }
  }
}
