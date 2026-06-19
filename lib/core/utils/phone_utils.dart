import 'package:country_picker/country_picker.dart';
import 'package:google_contacts_app/core/constants/app_constants.dart';

class PhoneUtils {
  PhoneUtils._();

  static Country get defaultCountry => Country.parse(AppConstants.defaultPhoneCountryIso);

  static String combinePhoneNumber(Country country, String localNumber) {
    final digits = localNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }
    return '+${country.phoneCode}$digits';
  }

  static ({Country country, String localNumber}) splitPhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return (country: defaultCountry, localNumber: '');
    }

    final trimmed = phone.trim();
    final digitsOnly = trimmed.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.isEmpty) {
      return (country: defaultCountry, localNumber: '');
    }

    if (!trimmed.startsWith('+')) {
      return (country: defaultCountry, localNumber: digitsOnly);
    }

    final matchedCountry = _matchCountryByDialCode(digitsOnly);
    if (matchedCountry == null) {
      return (country: defaultCountry, localNumber: digitsOnly);
    }

    final localNumber = digitsOnly.substring(matchedCountry.phoneCode.length);
    return (country: matchedCountry, localNumber: localNumber);
  }

  static Country? _matchCountryByDialCode(String digitsOnly) {
    Country? bestMatch;
    var bestCodeLength = 0;

    for (final country in CountryService().getAll()) {
      final code = country.phoneCode;
      if (digitsOnly.startsWith(code) && code.length > bestCodeLength) {
        bestMatch = country;
        bestCodeLength = code.length;
      }
    }

    return bestMatch;
  }
}
