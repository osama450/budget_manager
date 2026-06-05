/// Tunable thresholds + defaults derived from the source spreadsheet.
class BudgetConstants {
  BudgetConstants._();

  // Status tiers by spend ratio (spent / allocated):
  //   ratio  < within  -> low      (green)
  //   within <= ratio < near  -> within (yellow)
  //   near   <= ratio <= over  -> near   (orange)
  //   ratio  > over            -> over   (red)
  static const double withinThreshold = 0.5;
  static const double nearThreshold = 0.9;
  static const double overThreshold = 1.0;

  // Next-month suggestion heuristic.
  static const double suggestOverFactor = 1.05; // over budget -> spent * 1.05
  static const double suggestLowFactor = 1.10; // low use -> trim toward spent * 1.10
  static const double roundStep = 10.0; // round suggestions to nearest 10

  static const List<String> defaultCategoriesEn = [
    'Rent',
    'Groceries & Food',
    'Gas / Transport',
    'Electricity',
    'Internet',
    'Entertainment',
    'Health & Medicine',
    'Subscriptions',
  ];

  static const List<String> defaultCategoriesAr = [
    'إيجار',
    'بقالة وطعام',
    'بنزين/مواصلات',
    'كهرباء',
    'إنترنت',
    'ترفيه',
    'صحة وأدوية',
    'اشتراكات',
  ];

  static const String defaultCurrency = 'ج.م';
}
