import '../../core/constants/budget_constants.dart';

class AppSettings {
  final double openingBalance;
  final String currencySymbol;
  final String localeCode; // 'en' | 'ar'
  final String currentMonthId; // 'YYYY-MM'
  final int monthStartMillis;

  const AppSettings({
    this.openingBalance = 0,
    this.currencySymbol = BudgetConstants.defaultCurrency,
    this.localeCode = 'en',
    this.currentMonthId = '',
    this.monthStartMillis = 0,
  });

  AppSettings copyWith({
    double? openingBalance,
    String? currencySymbol,
    String? localeCode,
    String? currentMonthId,
    int? monthStartMillis,
  }) {
    return AppSettings(
      openingBalance: openingBalance ?? this.openingBalance,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      localeCode: localeCode ?? this.localeCode,
      currentMonthId: currentMonthId ?? this.currentMonthId,
      monthStartMillis: monthStartMillis ?? this.monthStartMillis,
    );
  }

  Map<String, dynamic> toMap() => {
        'openingBalance': openingBalance,
        'currencySymbol': currencySymbol,
        'localeCode': localeCode,
        'currentMonthId': currentMonthId,
        'monthStartMillis': monthStartMillis,
      };

  factory AppSettings.fromMap(Map map) => AppSettings(
        openingBalance: (map['openingBalance'] as num?)?.toDouble() ?? 0,
        currencySymbol:
            map['currencySymbol'] as String? ?? BudgetConstants.defaultCurrency,
        localeCode: map['localeCode'] as String? ?? 'en',
        currentMonthId: map['currentMonthId'] as String? ?? '',
        monthStartMillis: (map['monthStartMillis'] as num?)?.toInt() ?? 0,
      );
}
