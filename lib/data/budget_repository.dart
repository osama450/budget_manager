import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/budget_constants.dart';
import '../domain/budget_status.dart';
import 'models/app_settings.dart';
import 'models/archived_month.dart';
import 'models/category_model.dart';
import 'models/transaction_model.dart';

/// All persistence lives here. Models are stored as plain Maps in Hive boxes —
/// no codegen, no adapters. Spend is always derived from transactions.
class BudgetRepository {
  BudgetRepository._(
    this._settings,
    this._categories,
    this._transactions,
    this._archived,
  );

  final Box _settings;
  final Box _categories;
  final Box _transactions;
  final Box _archived;

  static const _settingsKey = 'data';
  static final _uuid = Uuid();

  static Future<BudgetRepository> open({
    required String initialLocale,
    bool useFlutterInit = true,
  }) async {
    if (useFlutterInit) await Hive.initFlutter();
    final repo = BudgetRepository._(
      await Hive.openBox('settings'),
      await Hive.openBox('categories'),
      await Hive.openBox('transactions'),
      await Hive.openBox('archived'),
    );
    repo._seedIfNeeded(initialLocale);
    return repo;
  }

  // ---------------- settings ----------------
  AppSettings getSettings() {
    final raw = _settings.get(_settingsKey);
    return raw is Map ? AppSettings.fromMap(raw) : const AppSettings();
  }

  void saveSettings(AppSettings s) => _settings.put(_settingsKey, s.toMap());

  // ---------------- categories ----------------
  List<CategoryModel> getCategories() {
    final list = _categories.values
        .whereType<Map>()
        .map(CategoryModel.fromMap)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  void addCategory(String name, double allocated) {
    final cat = CategoryModel(
      id: _uuid.v4(),
      name: name,
      allocated: allocated,
      order: _categories.length,
    );
    _categories.put(cat.id, cat.toMap());
  }

  void updateCategory(CategoryModel cat) =>
      _categories.put(cat.id, cat.toMap());

  void deleteCategory(String id) {
    _categories.delete(id);
    final orphanKeys = _transactions.keys.where((k) {
      final m = _transactions.get(k);
      return m is Map && m['categoryId'] == id;
    }).toList();
    _transactions.deleteAll(orphanKeys);
  }

  // ---------------- transactions ----------------
  List<TransactionModel> getTransactions() => _transactions.values
      .whereType<Map>()
      .map(TransactionModel.fromMap)
      .toList();

  void addTransaction({
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) {
    final tx = TransactionModel(
      id: _uuid.v4(),
      categoryId: categoryId,
      amount: amount,
      date: date,
      note: note,
      monthId: getSettings().currentMonthId,
    );
    _transactions.put(tx.id, tx.toMap());
  }

  void updateTransaction(TransactionModel tx) =>
      _transactions.put(tx.id, tx.toMap());

  void deleteTransaction(String id) => _transactions.delete(id);

  // ---------------- archive / new month ----------------
  List<ArchivedMonth> getArchivedMonths() => _archived.values
      .whereType<Map>()
      .map(ArchivedMonth.fromMap)
      .toList()
    ..sort((a, b) => b.id.compareTo(a.id));

  /// Snapshot the current cycle, roll leftover into the new opening balance,
  /// advance the month id. Categories + their transactions are kept.
  AppSettings startNewMonth() {
    final s = getSettings();
    final cats = getCategories();
    final monthTx =
        getTransactions().where((t) => t.monthId == s.currentMonthId).toList();

    final spentByCat = <String, double>{};
    for (final t in monthTx) {
      spentByCat[t.categoryId] = (spentByCat[t.categoryId] ?? 0) + t.amount;
    }

    double totalAllocated = 0, totalSpent = 0;
    final archCats = <ArchivedCategory>[];
    for (final c in cats) {
      final spent = spentByCat[c.id] ?? 0;
      totalAllocated += c.allocated;
      totalSpent += spent;
      final ratio = c.allocated <= 0 ? 0.0 : spent / c.allocated;
      final status = statusFor(allocated: c.allocated, ratio: ratio);
      archCats.add(ArchivedCategory(
        name: c.name,
        allocated: c.allocated,
        spent: spent,
        suggested: suggestBudget(
            allocated: c.allocated, spent: spent, status: status),
      ));
    }

    final remaining = s.openingBalance - totalSpent;
    final archived = ArchivedMonth(
      id: s.currentMonthId,
      openingBalance: s.openingBalance,
      totalAllocated: totalAllocated,
      totalSpent: totalSpent,
      remaining: remaining,
      categories: archCats,
      transactionCount: monthTx.length,
      archivedAtMillis: DateTime.now().millisecondsSinceEpoch,
    );
    _archived.put(archived.id, archived.toMap());

    final newSettings = s.copyWith(
      openingBalance: remaining, // rollover
      currentMonthId: _nextMonthId(s.currentMonthId),
      monthStartMillis: DateTime.now().millisecondsSinceEpoch,
    );
    saveSettings(newSettings);
    return newSettings;
  }

  /// Adopt the most recent archived month's suggested budgets (matched by name).
  void applySuggestedBudgets() {
    final months = getArchivedMonths();
    if (months.isEmpty) return;
    final byName = {for (final c in months.first.categories) c.name: c.suggested};
    for (final c in getCategories()) {
      final suggested = byName[c.name];
      if (suggested != null) updateCategory(c.copyWith(allocated: suggested));
    }
  }

  // ---------------- seed ----------------
  void _seedIfNeeded(String initialLocale) {
    final hasSettings = _settings.get(_settingsKey) is Map;
    if (hasSettings && _categories.isNotEmpty) return;

    if (!hasSettings) {
      saveSettings(AppSettings(
        localeCode: initialLocale,
        currentMonthId: _monthIdFromDate(DateTime.now()),
        monthStartMillis: DateTime.now().millisecondsSinceEpoch,
      ));
    }
    if (_categories.isEmpty) {
      final names = initialLocale == 'ar'
          ? BudgetConstants.defaultCategoriesAr
          : BudgetConstants.defaultCategoriesEn;
      for (var i = 0; i < names.length; i++) {
        final cat = CategoryModel(
            id: _uuid.v4(), name: names[i], allocated: 0, order: i);
        _categories.put(cat.id, cat.toMap());
      }
    }
  }

  static String _monthIdFromDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  static String _nextMonthId(String current) {
    final parts = current.split('-');
    final now = DateTime.now();
    final y = (parts.isNotEmpty ? int.tryParse(parts[0]) : null) ?? now.year;
    final m = (parts.length > 1 ? int.tryParse(parts[1]) : null) ?? now.month;
    return _monthIdFromDate(DateTime(y, m + 1));
  }
}
