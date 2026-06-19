import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_contacts_app/app/themes/app_text_styles.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';
import 'package:google_contacts_app/core/errors/result.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/app_snackbar.dart';
import 'package:google_contacts_app/core/utils/contact_list_refresh.dart';
import 'package:google_contacts_app/core/widgets/custom_bottom_sheet.dart';
import 'package:google_contacts_app/domain/usecases/delete_contact.dart';
import 'package:google_contacts_app/domain/usecases/get_all_contacts.dart';
import 'package:google_contacts_app/features/auth/controllers/auth_controller.dart';
import 'package:google_contacts_app/gen/assets.gen.dart';

class SettingsController extends GetxController {
  SettingsController({required GetAllContacts getAllContacts, required DeleteContact deleteContact})
    : _getAllContacts = getAllContacts,
      _deleteContact = deleteContact;

  final GetAllContacts _getAllContacts;
  final DeleteContact _deleteContact;

  final RxString themeMode = AppThemePreference.system.obs;
  final RxString defaultCountryCode = AppConstants.defaultCountryCode.obs;
  final RxInt contactCount = 0.obs;
  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStorageInfo();
  }

  void setThemeMode(String value) {
    themeMode.value = value;
    Get.changeThemeMode(switch (value) {
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
      _ => ThemeMode.system,
    });
  }

  String get themeModeLabel => switch (themeMode.value) {
    AppThemePreference.light => AppStrings.T.light,
    AppThemePreference.dark => AppStrings.T.dark,
    _ => AppStrings.T.system,
  };

  Future<void> showThemePicker() async {
    final context = Get.context;
    if (context == null) {
      return;
    }

    await AppBottomSheet.show(
      context: context,
      title: AppStrings.T.theme,
      content: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOptionTile(
              label: AppStrings.T.system,
              value: AppThemePreference.system,
              groupValue: themeMode.value,
              onSelected: _selectThemeAndClose,
            ),
            _ThemeOptionTile(
              label: AppStrings.T.light,
              value: AppThemePreference.light,
              groupValue: themeMode.value,
              onSelected: _selectThemeAndClose,
            ),
            _ThemeOptionTile(
              label: AppStrings.T.dark,
              value: AppThemePreference.dark,
              groupValue: themeMode.value,
              onSelected: _selectThemeAndClose,
            ),
          ],
        ),
      ),
    );
  }

  void _selectThemeAndClose(String value) {
    setThemeMode(value);
    Get.back();
  }

  Future<void> loadStorageInfo() async {
    final result = await _getAllContacts();
    switch (result) {
      case Success(data: final data):
        contactCount.value = data.length;
      case Failure(message: final message):
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  Future<void> deleteAllContacts() async {
    final firstConfirm = await AppBottomSheet.showConfirm(
      title: AppStrings.T.deleteAllContacts,
      icon: Assets.icons.icDelete,
      message: AppStrings.T.deleteAllContactsMessage,
    );
    if (!firstConfirm) {
      return;
    }

    final secondConfirm = await AppBottomSheet.showConfirm(
      title: AppStrings.T.areYouAbsolutelySure,
      message: AppStrings.T.actionCannotBeUndone,
    );
    if (!secondConfirm) {
      return;
    }

    isProcessing.value = true;
    final result = await _getAllContacts();
    switch (result) {
      case Success(data: final contacts):
        for (final contact in contacts) {
          await _deleteContact(contact.id);
        }
        isProcessing.value = false;
        await loadStorageInfo();
        await refreshContactLists();
        AppSnackbar.success(AppStrings.T.deleted, AppStrings.T.allContactsRemoved);
      case Failure(message: final message):
        isProcessing.value = false;
        AppSnackbar.error(AppStrings.T.error, message);
    }
  }

  Future<void> signOut() async {
    final confirmed = await AppBottomSheet.showConfirm(
      title: AppStrings.T.signOut,
      icon: Assets.icons.icLogout,
      message: AppStrings.T.signOutMessage,
    );
    if (!confirmed) {
      return;
    }

    isProcessing.value = true;
    await Get.find<AuthController>().signOut();
    isProcessing.value = false;
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = value == groupValue;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: AppTextStyles.bodyLarge),
      trailing: isSelected
          ? Icon(Icons.check, color: colorScheme.primary)
          : null,
      onTap: () => onSelected(value),
    );
  }
}
