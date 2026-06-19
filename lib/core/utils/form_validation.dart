import 'package:country_phone_validator/country_phone_validator.dart';
import 'package:google_contacts_app/core/l10n/app_strings.dart';
import 'package:google_contacts_app/core/utils/date_utils.dart';

class Validator {
  static final RegExp _emailRegex = RegExp(
    r'^[\w\.-]+(\+[\w-]+)?@([\w-]+\.)+[\w-]{2,4}$',
  );
  static final RegExp _nameRegex = RegExp(r"^[a-zA-Z\s\-\']+$");

  static bool _isEmpty(String? value) => value == null || value.trim().isEmpty;

  // --------------------------------------------------------------------------
  // Email
  // --------------------------------------------------------------------------
  static String? validateOptionalEmail(String? email) {
    if (_isEmpty(email)) return null;

    if (!_emailRegex.hasMatch(email!.trim())) {
      return AppStrings.T.pleaseEnterAValidEmail;
    }

    return null;
  }

  // --------------------------------------------------------------------------
  // Name
  // --------------------------------------------------------------------------
  static String? validateName(
    String? name,
    String fieldLabel,
    String fieldValidationMessage,
  ) {
    if (_isEmpty(name)) return fieldLabel;

    final trimmedName = name!.trim();

    if (trimmedName.length < 2)
      return AppStrings.T.nameMustBeAtLeast2Characters;
    if (!_nameRegex.hasMatch(trimmedName)) {
      return fieldValidationMessage;
    }

    return null;
  }

  // --------------------------------------------------------------------------
  // Birthday
  // --------------------------------------------------------------------------
  static String? validateOptionalBirthday(DateTime? birthday) {
    if (birthday == null) return null;

    final today = DateUtilsX.now();
    final selectedDate = DateTime(birthday.year, birthday.month, birthday.day);
    final todayDate = DateTime(today.year, today.month, today.day);

    if (selectedDate.isAfter(todayDate)) {
      return AppStrings.T.dateOfBirthCannotBeInTheFuture;
    }

    return null;
  }

  // --------------------------------------------------------------------------
  // Phone Number
  // --------------------------------------------------------------------------
  static String? validatePhoneNumber(
    String? value, {
    required String dialCode,
  }) {
    if (_isEmpty(value)) return AppStrings.T.pleaseEnterMobileNumber;

    final phoneNumber = value!.trim();
    final formattedDialCode = dialCode.startsWith('+')
        ? dialCode
        : '+$dialCode';

    if (!CountryUtils.validatePhoneNumber(phoneNumber, formattedDialCode)) {
      return AppStrings.T.pleaseEnterAValidMobileNumber;
    }

    return null;
  }
}
