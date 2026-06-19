import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/date_utils.dart';
import 'package:google_contacts_app/core/utils/form_validation.dart';
import 'package:google_contacts_app/core/utils/responsive.dart';
import 'package:google_contacts_app/core/widgets/app_avatar.dart';
import 'package:google_contacts_app/core/widgets/phone_number_field.dart';
import 'package:google_contacts_app/features/contact_form/controllers/contact_form_controller.dart';

class ContactFormView extends GetView<ContactFormController> {
  const ContactFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final shouldPop = await controller.handleWillPop();
        if (shouldPop) {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.isEditMode ? AppStrings.T.editContact : AppStrings.T.addContact,
              style: AppTextStyles.appBarTitle,
            ),
          ),
          actions: [
            Obx(
              () => controller.isSaving.value
                  ? Padding(
                      padding: EdgeInsets.all(Rs.dp(16)),
                      child: SizedBox(
                        width: Rs.dp(20),
                        height: Rs.dp(20),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : TextButton(
                      onPressed: controller.saveContact,
                      child: Text(AppStrings.T.save, style: AppTextStyles.buttonText),
                    ),
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Rs.dp(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AvatarPreview(),
                  SizedBox(height: Rs.dp(16)),
                  _TextField(
                    controller: controller.firstNameController,
                    label: AppStrings.T.firstName,
                    required: true,
                    validator: (value) => Validator.validateName(
                      value,
                      AppStrings.T.pleaseEnterFirstName,
                      AppStrings.T.firstNameCannotContainNumbersOrSpecialCharacters,
                    ),
                  ),
                  _TextField(
                    controller: controller.lastNameController,
                    label: AppStrings.T.lastName,
                  ),
                  _TextField(
                    controller: controller.nicknameController,
                    label: AppStrings.T.nickname,
                  ),
                  _TextField(controller: controller.companyController, label: AppStrings.T.company),
                  _TextField(
                    controller: controller.jobTitleController,
                    label: AppStrings.T.jobTitle,
                  ),
                  _TextField(
                    controller: controller.departmentController,
                    label: AppStrings.T.department,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Rs.dp(12)),
                    child: PhoneNumberField(
                      controller: controller.phoneController,
                      selectedCountry: controller.selectedCountry,
                      onCountryChanged: controller.onCountryChanged,
                      hintText: AppStrings.T.enterMobileNumber,
                    ),
                  ),
                  _TextField(
                    controller: controller.emailController,
                    label: AppStrings.T.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validator.validateOptionalEmail,
                  ),
                  _BirthdayField(),
                  _TextField(
                    controller: controller.notesController,
                    label: AppStrings.T.notes,
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarPreview extends GetView<ContactFormController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        controller.avatarPreviewVersion.value;
        return AppAvatar(
          contact: controller.avatarPreviewContact,
          size: Rs.dp(96),
          style: AppAvatarStyle.pastel,
        );
      }),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.required = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool required;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Rs.dp(12)),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          labelStyle: AppTextStyles.bodyMedium,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: AppTextStyles.bodyMedium,
      ),
    );
  }
}

class _BirthdayField extends GetView<ContactFormController> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(
      () => FormField<DateTime?>(
        key: ValueKey(controller.birthday.value?.millisecondsSinceEpoch ?? 'empty'),
        initialValue: controller.birthday.value,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: Validator.validateOptionalBirthday,
        builder: (field) {
          final today = DateTime.now();
          final selected = field.value;
          final initialDate = selected == null || selected.isAfter(today) ? today : selected;

          return Padding(
            padding: EdgeInsets.only(bottom: Rs.dp(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppStrings.T.birthday, style: AppTextStyles.bodyMedium),
                  subtitle: Text(
                    field.value == null
                        ? AppStrings.T.notSet
                        : DateUtilsX.formatBirthday(field.value),
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: today,
                    );
                    if (date != null) {
                      final normalized = DateUtilsX.normalizeBirthday(date);
                      field.didChange(normalized);
                      controller.setBirthday(normalized);
                    }
                  },
                ),
                if (field.hasError)
                  Padding(
                    padding: EdgeInsets.only(left: Rs.dp(4)),
                    child: Text(
                      field.errorText!,
                      style: AppTextStyles.bodySmall.copyWith(color: colorScheme.error),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
