// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Monthly Budget';

  @override
  String get summaryTitle => 'Balance & Summary';

  @override
  String get available => 'Available';

  @override
  String get openingBalance => 'Total Funds';

  @override
  String get allocated => 'Allocated';

  @override
  String get spent => 'Spent';

  @override
  String get unallocated => 'Unallocated';

  @override
  String get netCommitment => 'Net commitment';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get transactionsTitle => 'Recent Transactions';

  @override
  String get analyticsTitle => 'Insights';

  @override
  String get addCategory => 'Add Category';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get newMonth => 'New Month';

  @override
  String get startNewMonth => 'Start a New Month';

  @override
  String get history => 'History';

  @override
  String get categoryName => 'Category name';

  @override
  String get budgetLimit => 'Budget limit';

  @override
  String get amount => 'Amount';

  @override
  String get note => 'Note (optional)';

  @override
  String get date => 'Date';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get selectCategory => 'Select category';

  @override
  String get statusOver => 'Over budget';

  @override
  String get statusNear => 'Near limit';

  @override
  String get statusWithin => 'Within rate';

  @override
  String get statusLow => 'Low use';

  @override
  String get statusNoBudget => 'No budget';

  @override
  String get suggested => 'Suggested';

  @override
  String get suggestedForNextMonth => 'Suggested budget for next month';

  @override
  String get applySuggested => 'Apply suggested budgets';

  @override
  String get overBudgetLabel => 'Over budget';

  @override
  String get topSpender => 'Top spender';

  @override
  String get lowUseLabel => 'Low use';

  @override
  String get mostOver => 'Most over';

  @override
  String get largestUnused => 'Largest unused';

  @override
  String get commitmentRatio => 'Budget used';

  @override
  String get emptyCategories => 'No categories yet. Tap + to add one.';

  @override
  String get emptyTransactions => 'No transactions yet.';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidAmount => 'Enter a valid amount';

  @override
  String get duplicateName => 'Name already exists';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get setOpeningBalance => 'Set total funds';

  @override
  String get confirm => 'Confirm';

  @override
  String get deleteCategoryConfirm =>
      'Delete this category and all its transactions?';

  @override
  String get deleteTransactionConfirm => 'Delete this transaction?';

  @override
  String get archivedMonths => 'Archived Months';

  @override
  String get noHistory => 'No archived months yet.';

  @override
  String get none => 'None';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String categoryCountOver(int count) {
    return '$count';
  }

  @override
  String newMonthExplain(String month, String amount) {
    return 'This archives $month and starts fresh. Spent resets to 0 and your categories stay. Leftover $amount rolls over as your new balance.';
  }

  @override
  String valueOfTotal(String value, String total) {
    return '$value of $total';
  }
}
