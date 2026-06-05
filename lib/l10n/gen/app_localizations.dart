import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get appTitle;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance & Summary'**
  String get summaryTitle;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Funds'**
  String get openingBalance;

  /// No description provided for @allocated.
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get allocated;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @unallocated.
  ///
  /// In en, this message translates to:
  /// **'Unallocated'**
  String get unallocated;

  /// No description provided for @netCommitment.
  ///
  /// In en, this message translates to:
  /// **'Net commitment'**
  String get netCommitment;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get transactionsTitle;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get analyticsTitle;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @newMonth.
  ///
  /// In en, this message translates to:
  /// **'New Month'**
  String get newMonth;

  /// No description provided for @startNewMonth.
  ///
  /// In en, this message translates to:
  /// **'Start a New Month'**
  String get startNewMonth;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @budgetLimit.
  ///
  /// In en, this message translates to:
  /// **'Budget limit'**
  String get budgetLimit;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get note;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @statusOver.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get statusOver;

  /// No description provided for @statusNear.
  ///
  /// In en, this message translates to:
  /// **'Near limit'**
  String get statusNear;

  /// No description provided for @statusWithin.
  ///
  /// In en, this message translates to:
  /// **'Within rate'**
  String get statusWithin;

  /// No description provided for @statusLow.
  ///
  /// In en, this message translates to:
  /// **'Low use'**
  String get statusLow;

  /// No description provided for @statusNoBudget.
  ///
  /// In en, this message translates to:
  /// **'No budget'**
  String get statusNoBudget;

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get suggested;

  /// No description provided for @suggestedForNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Suggested budget for next month'**
  String get suggestedForNextMonth;

  /// No description provided for @applySuggested.
  ///
  /// In en, this message translates to:
  /// **'Apply suggested budgets'**
  String get applySuggested;

  /// No description provided for @overBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Over budget'**
  String get overBudgetLabel;

  /// No description provided for @topSpender.
  ///
  /// In en, this message translates to:
  /// **'Top spender'**
  String get topSpender;

  /// No description provided for @lowUseLabel.
  ///
  /// In en, this message translates to:
  /// **'Low use'**
  String get lowUseLabel;

  /// No description provided for @mostOver.
  ///
  /// In en, this message translates to:
  /// **'Most over'**
  String get mostOver;

  /// No description provided for @largestUnused.
  ///
  /// In en, this message translates to:
  /// **'Largest unused'**
  String get largestUnused;

  /// No description provided for @commitmentRatio.
  ///
  /// In en, this message translates to:
  /// **'Budget used'**
  String get commitmentRatio;

  /// No description provided for @emptyCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories yet. Tap + to add one.'**
  String get emptyCategories;

  /// No description provided for @emptyTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get emptyTransactions;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get invalidAmount;

  /// No description provided for @duplicateName.
  ///
  /// In en, this message translates to:
  /// **'Name already exists'**
  String get duplicateName;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @setOpeningBalance.
  ///
  /// In en, this message translates to:
  /// **'Set total funds'**
  String get setOpeningBalance;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this category and all its transactions?'**
  String get deleteCategoryConfirm;

  /// No description provided for @deleteTransactionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this transaction?'**
  String get deleteTransactionConfirm;

  /// No description provided for @archivedMonths.
  ///
  /// In en, this message translates to:
  /// **'Archived Months'**
  String get archivedMonths;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No archived months yet.'**
  String get noHistory;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No transactions} =1{1 transaction} other{{count} transactions}}'**
  String transactionCount(int count);

  /// No description provided for @categoryCountOver.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String categoryCountOver(int count);

  /// No description provided for @newMonthExplain.
  ///
  /// In en, this message translates to:
  /// **'This archives {month} and starts fresh. Spent resets to 0 and your categories stay. Leftover {amount} rolls over as your new balance.'**
  String newMonthExplain(String month, String amount);

  /// No description provided for @valueOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{value} of {total}'**
  String valueOfTotal(String value, String total);
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
