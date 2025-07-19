import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get newTransaction;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction'**
  String get deleteTransaction;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @selectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select account'**
  String get selectAccount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @validationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get validationErrorTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get loadingError;

  /// No description provided for @categoriesLoadingError.
  ///
  /// In en, this message translates to:
  /// **'Categories loading error'**
  String get categoriesLoadingError;

  /// No description provided for @selectTransactionTypeFirst.
  ///
  /// In en, this message translates to:
  /// **'Select transaction type first'**
  String get selectTransactionTypeFirst;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @sum.
  ///
  /// In en, this message translates to:
  /// **'Sum'**
  String get sum;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @sorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sorting;

  /// No description provided for @sorting_date_newest.
  ///
  /// In en, this message translates to:
  /// **'By date (newest first)'**
  String get sorting_date_newest;

  /// No description provided for @sorting_date_oldest.
  ///
  /// In en, this message translates to:
  /// **'By date (oldest first)'**
  String get sorting_date_oldest;

  /// No description provided for @sorting_amount_desc.
  ///
  /// In en, this message translates to:
  /// **'By amount (descending)'**
  String get sorting_amount_desc;

  /// No description provided for @sorting_amount_asc.
  ///
  /// In en, this message translates to:
  /// **'By amount (ascending)'**
  String get sorting_amount_asc;

  /// No description provided for @analysis_income.
  ///
  /// In en, this message translates to:
  /// **'Income analysis'**
  String get analysis_income;

  /// No description provided for @analysis_expense.
  ///
  /// In en, this message translates to:
  /// **'Expense analysis'**
  String get analysis_expense;

  /// No description provided for @my_account.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get my_account;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @account_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get account_name;

  /// No description provided for @by_days.
  ///
  /// In en, this message translates to:
  /// **'By days'**
  String get by_days;

  /// No description provided for @by_months.
  ///
  /// In en, this message translates to:
  /// **'By months'**
  String get by_months;

  /// No description provided for @my_articles.
  ///
  /// In en, this message translates to:
  /// **'My articles'**
  String get my_articles;

  /// No description provided for @search_article.
  ///
  /// In en, this message translates to:
  /// **'Search article'**
  String get search_article;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @pinSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'PIN settings screen'**
  String get pinSettingsButton;

  /// No description provided for @languageSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageSettingTitle;

  /// No description provided for @russianLanguage.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russianLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @primaryColorSetting.
  ///
  /// In en, this message translates to:
  /// **'Primary color'**
  String get primaryColorSetting;

  /// No description provided for @colorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose primary color'**
  String get colorPickerTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @darkThemeSetting.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkThemeSetting;

  /// No description provided for @darkThemeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get darkThemeEnabled;

  /// No description provided for @darkThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get darkThemeSystem;

  /// No description provided for @pinSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'PIN Settings'**
  String get pinSettingsTitle;

  /// No description provided for @setPinButton.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPinButton;

  /// No description provided for @changePinButton.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinButton;

  /// No description provided for @removePinButton.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get removePinButton;

  /// No description provided for @biometricAuthLabel.
  ///
  /// In en, this message translates to:
  /// **'Biometric login'**
  String get biometricAuthLabel;

  /// No description provided for @setPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPinTitle;

  /// No description provided for @updatePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get updatePinTitle;

  /// No description provided for @deletePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete PIN'**
  String get deletePinTitle;

  /// No description provided for @confirmPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get confirmPinTitle;

  /// No description provided for @currentPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPinLabel;

  /// No description provided for @newPinLabel.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPinLabel;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @biometricAuthButton.
  ///
  /// In en, this message translates to:
  /// **'Login with biometrics'**
  String get biometricAuthButton;

  /// No description provided for @pinSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN set successfully'**
  String get pinSetSuccess;

  /// No description provided for @pinUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN updated successfully'**
  String get pinUpdatedSuccess;

  /// No description provided for @pinDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN deleted successfully'**
  String get pinDeletedSuccess;

  /// No description provided for @pinValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN'**
  String get pinValidationFailed;

  /// No description provided for @hapticFeedbackSetting.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticFeedbackSetting;

  /// No description provided for @hapticFeedbackEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get hapticFeedbackEnabled;

  /// No description provided for @hapticFeedbackDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get hapticFeedbackDisabled;

  /// No description provided for @confirmNewPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get confirmNewPinLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
