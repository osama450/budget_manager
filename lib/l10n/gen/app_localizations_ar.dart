// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'الميزانية الشهرية';

  @override
  String get summaryTitle => 'الرصيد والملخّص';

  @override
  String get available => 'المتاح';

  @override
  String get openingBalance => 'الرصيد الافتتاحي';

  @override
  String get allocated => 'المخصّص';

  @override
  String get spent => 'المصروف';

  @override
  String get unallocated => 'غير المخصّص';

  @override
  String get netCommitment => 'صافي الالتزام';

  @override
  String get categoriesTitle => 'البنود';

  @override
  String get transactionsTitle => 'أحدث المعاملات';

  @override
  String get analyticsTitle => 'التحليلات';

  @override
  String get addCategory => 'إضافة بند';

  @override
  String get addTransaction => 'إضافة معاملة';

  @override
  String get editCategory => 'تعديل البند';

  @override
  String get editTransaction => 'تعديل المعاملة';

  @override
  String get newMonth => 'شهر جديد';

  @override
  String get startNewMonth => 'ابدأ شهرًا جديدًا';

  @override
  String get history => 'السجل';

  @override
  String get categoryName => 'اسم البند';

  @override
  String get budgetLimit => 'الميزانية المخصّصة';

  @override
  String get amount => 'المبلغ';

  @override
  String get note => 'ملاحظة (اختياري)';

  @override
  String get date => 'التاريخ';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get selectCategory => 'اختر البند';

  @override
  String get statusOver => 'تجاوز الميزانية';

  @override
  String get statusNear => 'اقترب من الحد';

  @override
  String get statusWithin => 'ضمن المعدل';

  @override
  String get statusLow => 'منخفض الاستهلاك';

  @override
  String get statusNoBudget => 'بدون ميزانية';

  @override
  String get suggested => 'المقترح';

  @override
  String get suggestedForNextMonth => 'الميزانية المقترحة للشهر القادم';

  @override
  String get applySuggested => 'اعتماد الميزانية المقترحة';

  @override
  String get overBudgetLabel => 'بنود متجاوِزة';

  @override
  String get topSpender => 'الأعلى صرفًا';

  @override
  String get lowUseLabel => 'منخفضة الاستهلاك';

  @override
  String get mostOver => 'الأكثر تجاوزًا';

  @override
  String get largestUnused => 'الأكبر غير مُستغل';

  @override
  String get commitmentRatio => 'نسبة الالتزام';

  @override
  String get emptyCategories => 'لا توجد بنود بعد. اضغط + للإضافة.';

  @override
  String get emptyTransactions => 'لا توجد معاملات بعد.';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get invalidAmount => 'أدخل مبلغًا صحيحًا';

  @override
  String get duplicateName => 'الاسم موجود مسبقًا';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get setOpeningBalance => 'تعيين الرصيد الافتتاحي';

  @override
  String get currency => 'العملة';

  @override
  String get custom => 'مخصّص';

  @override
  String get confirm => 'تأكيد';

  @override
  String get deleteCategoryConfirm => 'حذف هذا البند وكل معاملاته؟';

  @override
  String get deleteTransactionConfirm => 'حذف هذه المعاملة؟';

  @override
  String get archivedMonths => 'الأشهر المؤرشفة';

  @override
  String get noHistory => 'لا توجد أشهر مؤرشفة بعد.';

  @override
  String get none => 'لا يوجد';

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملة',
      many: '$count معاملة',
      few: '$count معاملات',
      two: 'معاملتان',
      one: 'معاملة واحدة',
      zero: 'لا معاملات',
    );
    return '$_temp0';
  }

  @override
  String categoryCountOver(int count) {
    return '$count';
  }

  @override
  String newMonthExplain(String month, String amount) {
    return 'سيؤرشف هذا $month ويبدأ من جديد. يُصفّر المصروف وتبقى بنودك كما هي. يُرحّل المتبقي $amount ليصبح رصيدك الجديد.';
  }

  @override
  String valueOfTotal(String value, String total) {
    return '$value من $total';
  }
}
