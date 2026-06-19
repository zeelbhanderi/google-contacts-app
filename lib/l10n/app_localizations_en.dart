// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Contacts';

  @override
  String get settings => 'Settings';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get defaultCountryCode => 'Default country code';

  @override
  String get display => 'Display';

  @override
  String get data => 'Data';

  @override
  String get account => 'Account';

  @override
  String get storageInfo => 'Storage info';

  @override
  String contactCount(Object count) {
    return '$count contacts';
  }

  @override
  String get deleteAllContacts => 'Delete all contacts';

  @override
  String get deleteAllContactsMessage => 'This will permanently delete all contacts on this device.';

  @override
  String get areYouAbsolutelySure => 'Are you absolutely sure?';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get allContactsRemoved => 'All contacts removed';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutMessage => 'Sign out of your Google account and clear local contacts from this device?';

  @override
  String get error => 'Error';

  @override
  String get deleted => 'Deleted';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get favorites => 'Favorites';

  @override
  String get contacts => 'Contacts';

  @override
  String get searchContacts => 'Search contacts';

  @override
  String get noContactsYet => 'No contacts yet';

  @override
  String get noContactsYetSubtitle => 'Add your first contact with the + button.';

  @override
  String get delete => 'Delete';

  @override
  String get favorite => 'Favorite';

  @override
  String get noFavorites => 'No favorites';

  @override
  String get noFavoritesSubtitle => 'Star contacts to see them here.';

  @override
  String get signInSubtitle => 'Sign in to sync your contacts across devices';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInFailed => 'Sign-in failed';

  @override
  String get signInFailedRetry => 'Sign-in failed. Please try again.';

  @override
  String get loading => 'Loading...';

  @override
  String get syncFailed => 'Sync failed';

  @override
  String get restoringContacts => 'Restoring your contacts...';

  @override
  String get noInternetConnection => 'No internet connection. Check your network and try again.';

  @override
  String get accountExistsDifferentCredential => 'An account already exists with a different sign-in method.';

  @override
  String get editContact => 'Edit contact';

  @override
  String get addContact => 'Add contact';

  @override
  String get save => 'Save';

  @override
  String get nickname => 'Nickname';

  @override
  String get company => 'Company';

  @override
  String get jobTitle => 'Job title';

  @override
  String get department => 'Department';

  @override
  String get phone => 'Phone';

  @override
  String get enterMobileNumber => 'Enter mobile number';

  @override
  String get search => 'Search';

  @override
  String get birthday => 'Birthday';

  @override
  String get notes => 'Notes';

  @override
  String get notSet => 'Not set';

  @override
  String get work => 'Work';

  @override
  String get website => 'Website';

  @override
  String get websites => 'Websites';

  @override
  String get call => 'Call';

  @override
  String get sms => 'SMS';

  @override
  String get email => 'Email';

  @override
  String get remove => 'Remove';

  @override
  String get discardChanges => 'Discard changes?';

  @override
  String get discardChangesMessage => 'You have unsaved changes. Discard them?';

  @override
  String get validationError => 'Validation error';

  @override
  String get deleteContact => 'Delete contact';

  @override
  String deleteContactMessage(Object name) {
    return 'Delete $name? This action cannot be undone.';
  }

  @override
  String get noPhoneNumberAvailable => 'No phone number available';

  @override
  String get noEmailAddressAvailable => 'No email address available';

  @override
  String get copied => 'Copied';

  @override
  String get phoneNumberCopied => 'Phone number copied';

  @override
  String get emailCopied => 'Email copied';

  @override
  String couldNotOpenUri(Object uri) {
    return 'Could not open $uri';
  }

  @override
  String get contactDeleted => 'Contact deleted';

  @override
  String get undo => 'Undo';

  @override
  String birthdayWithAge(Object age, Object date) {
    return '$date ($age years old)';
  }

  @override
  String get pleaseEnterFirstName => 'Please enter first name';

  @override
  String get nameMustBeAtLeast2Characters => 'Name must be at least 2 characters';

  @override
  String get firstNameCannotContainNumbersOrSpecialCharacters => 'First name cannot contain numbers or special characters';

  @override
  String get lastNameCannotContainNumbersOrSpecialCharacters => 'Last Name cannot contain numbers or special characters';

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterMobileNumber => 'Please enter mobile number';

  @override
  String get pleaseEnterAValidMobileNumber => 'Please enter a valid mobile number';

  @override
  String get dateOfBirthCannotBeInTheFuture => 'Date of birth cannot be in the future';
}
