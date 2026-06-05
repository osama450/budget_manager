import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/budget_repository.dart';
import '../data/models/app_settings.dart';
import '../data/models/archived_month.dart';
import '../data/models/category_model.dart';
import '../data/models/transaction_model.dart';

/// Overridden in main() with the opened repository instance.
final repositoryProvider = Provider<BudgetRepository>((ref) {
  throw UnimplementedError('repositoryProvider must be overridden');
});

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(repositoryProvider).getSettings();

  BudgetRepository get _repo => ref.read(repositoryProvider);

  void setOpeningBalance(double value) =>
      _save(state.copyWith(openingBalance: value));
  void setCurrency(String symbol) => _save(state.copyWith(currencySymbol: symbol));
  void setLocale(String code) => _save(state.copyWith(localeCode: code));
  void toggleLocale() => setLocale(state.localeCode == 'ar' ? 'en' : 'ar');

  void startNewMonth() {
    state = _repo.startNewMonth();
    ref.invalidate(archivedMonthsProvider);
  }

  void applySuggestedBudgets() {
    _repo.applySuggestedBudgets();
    ref.invalidate(categoriesProvider);
  }

  void _save(AppSettings s) {
    _repo.saveSettings(s);
    state = s;
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class CategoriesNotifier extends Notifier<List<CategoryModel>> {
  @override
  List<CategoryModel> build() => ref.read(repositoryProvider).getCategories();

  BudgetRepository get _repo => ref.read(repositoryProvider);

  void add(String name, double allocated) {
    _repo.addCategory(name, allocated);
    state = _repo.getCategories();
  }

  void update(CategoryModel cat) {
    _repo.updateCategory(cat);
    state = _repo.getCategories();
  }

  /// Overwrite allocations in bulk (id -> new budget). Used by "apply suggested".
  void applyAllocations(Map<String, double> byId) {
    for (final c in state) {
      final allocated = byId[c.id];
      if (allocated != null) _repo.updateCategory(c.copyWith(allocated: allocated));
    }
    state = _repo.getCategories();
  }

  void remove(String id) {
    _repo.deleteCategory(id);
    state = _repo.getCategories();
    ref.invalidate(transactionsProvider);
  }
}

final categoriesProvider =
    NotifierProvider<CategoriesNotifier, List<CategoryModel>>(
        CategoriesNotifier.new);

class TransactionsNotifier extends Notifier<List<TransactionModel>> {
  @override
  List<TransactionModel> build() =>
      ref.read(repositoryProvider).getTransactions();

  BudgetRepository get _repo => ref.read(repositoryProvider);

  void add({
    required String categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) {
    _repo.addTransaction(
        categoryId: categoryId, amount: amount, date: date, note: note);
    state = _repo.getTransactions();
  }

  void update(TransactionModel tx) {
    _repo.updateTransaction(tx);
    state = _repo.getTransactions();
  }

  void remove(String id) {
    _repo.deleteTransaction(id);
    state = _repo.getTransactions();
  }
}

final transactionsProvider =
    NotifierProvider<TransactionsNotifier, List<TransactionModel>>(
        TransactionsNotifier.new);

final archivedMonthsProvider = Provider<List<ArchivedMonth>>(
    (ref) => ref.watch(repositoryProvider).getArchivedMonths());
