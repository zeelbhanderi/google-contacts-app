import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/app_snackbar.dart';
import 'package:google_contacts_app/core/utils/contact_list_refresh.dart';
import 'package:google_contacts_app/core/utils/date_utils.dart';
import 'package:google_contacts_app/core/utils/phone_utils.dart';
import 'package:google_contacts_app/core/widgets/custom_bottom_sheet.dart';
import 'package:google_contacts_app/domain/entities/contact_entity.dart';
import 'package:google_contacts_app/domain/usecases/add_contact.dart';
import 'package:google_contacts_app/domain/usecases/update_contact.dart';
import 'package:uuid/uuid.dart';

class ContactFormController extends GetxController {
  ContactFormController({required AddContact addContact, required UpdateContact updateContact})
    : _addContact = addContact,
      _updateContact = updateContact;

  final AddContact _addContact;
  final UpdateContact _updateContact;
  final _uuid = const Uuid();

  final Rx<ContactEntity?> editingContact = Rx<ContactEntity?>(null);
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nicknameController = TextEditingController();
  final companyController = TextEditingController();
  final jobTitleController = TextEditingController();
  final departmentController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();

  final Rx<Country> selectedCountry = Country.parse(AppConstants.defaultPhoneCountryIso).obs;
  final Rx<DateTime?> birthday = Rx<DateTime?>(null);
  final RxInt avatarPreviewVersion = 0.obs;

  final RxBool isSaving = false.obs;
  final RxBool isDirty = false.obs;

  bool get isEditMode => editingContact.value != null;

  ContactEntity get avatarPreviewContact => ContactEntity(
    id: editingContact.value?.id ?? 'preview',
    firstName: firstNameController.text.trim(),
    lastName: lastNameController.text.trim(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void onInit() {
    super.onInit();
    firstNameController.addListener(_onNameChanged);
    lastNameController.addListener(_onNameChanged);
    firstNameController.addListener(_markDirty);
    lastNameController.addListener(_markDirty);
    nicknameController.addListener(_markDirty);
    companyController.addListener(_markDirty);
    jobTitleController.addListener(_markDirty);
    departmentController.addListener(_markDirty);
    phoneController.addListener(_markDirty);
    emailController.addListener(_markDirty);
    notesController.addListener(_markDirty);

    final argument = Get.arguments;
    if (argument is ContactEntity) {
      editingContact.value = argument;
      _populateForm(argument);
    }
  }

  @override
  void onClose() {
    firstNameController.removeListener(_onNameChanged);
    lastNameController.removeListener(_onNameChanged);
    firstNameController.dispose();
    lastNameController.dispose();
    nicknameController.dispose();
    companyController.dispose();
    jobTitleController.dispose();
    departmentController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void _onNameChanged() {
    avatarPreviewVersion.value++;
  }

  void _markDirty() {
    isDirty.value = true;
  }

  void onCountryChanged(Country country) {
    selectedCountry.value = country;
    isDirty.value = true;
  }

  void setBirthday(DateTime? value) {
    birthday.value = DateUtilsX.normalizeBirthday(value);
    isDirty.value = true;
  }

  Future<bool> handleWillPop() async {
    if (!isDirty.value) {
      return true;
    }

    return AppBottomSheet.showConfirm(
      title: AppStrings.T.discardChanges,
      message: AppStrings.T.discardChangesMessage,
    );
  }

  Future<void> saveContact() async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    form.save();
    isSaving.value = true;
    final entity = _buildContactEntity();
    final result = editingContact.value == null
        ? await _addContact(entity)
        : await _updateContact(entity);
    isSaving.value = false;

    switch (result) {
      case Success():
        isDirty.value = false;
        await refreshContactLists();
        Get.back(result: entity);
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  ContactEntity _buildContactEntity() {
    final now = DateTime.now();
    final existing = editingContact.value;

    return ContactEntity(
      id: existing?.id ?? _uuid.v4(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      nickname: _nullableText(nicknameController.text),
      phone: _nullableText(
        PhoneUtils.combinePhoneNumber(selectedCountry.value, phoneController.text),
      ),
      email: _nullableText(emailController.text),
      company: _nullableText(companyController.text),
      jobTitle: _nullableText(jobTitleController.text),
      department: _nullableText(departmentController.text),
      websiteUrls: existing?.websiteUrls ?? const [],
      birthday: DateUtilsX.normalizeBirthday(birthday.value),
      notes: _nullableText(notesController.text),
      isFavorite: existing?.isFavorite ?? false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
  }

  void _populateForm(ContactEntity contact) {
    firstNameController.text = contact.firstName;
    lastNameController.text = contact.lastName;
    nicknameController.text = contact.nickname ?? '';
    companyController.text = contact.company ?? '';
    jobTitleController.text = contact.jobTitle ?? '';
    departmentController.text = contact.department ?? '';
    emailController.text = contact.email ?? '';
    notesController.text = contact.notes ?? '';

    final parsedPhone = PhoneUtils.splitPhoneNumber(contact.phone);
    selectedCountry.value = parsedPhone.country;
    phoneController.text = parsedPhone.localNumber;

    birthday.value = DateUtilsX.normalizeBirthday(contact.birthday);
    avatarPreviewVersion.value++;
    isDirty.value = false;
  }

  String? _nullableText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
