abstract final class AppConstants {
  AppConstants._();

  static const appName = 'Contacts';
  static const defaultLocale = 'en';
  static const defaultCountryCode = '+91';
  static const defaultPhoneCountryIso = 'IN';

  static const undoSnackbarDuration = Duration(seconds: 5);
  static const searchDebounce = Duration(milliseconds: 300);
  static const scrollAnimationDuration = Duration(milliseconds: 300);
  static const remoteSyncTimeout = Duration(seconds: 10);
}

abstract final class HomeTabIndex {
  HomeTabIndex._();

  static const contacts = 0;
  static const favorites = 1;
}

abstract final class AppThemePreference {
  AppThemePreference._();

  static const system = 'system';
  static const light = 'light';
  static const dark = 'dark';
}

abstract final class ContactAlphabet {
  ContactAlphabet._();

  static const other = '#';
  static const firstLetter = 'A';
  static const lastLetter = 'Z';

  static const letters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    other,
  ];
}

abstract final class AuthErrorCode {
  AuthErrorCode._();

  static const signInCanceled = 'sign_in_canceled';
  static const googleSignInCanceled = '12501';
  static const canceledKeyword = 'canceled';
  static const networkRequestFailed = 'network-request-failed';
  static const accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
  static const networkError = 'network_error';
}
