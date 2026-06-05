import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/category_model.dart';
import '../data/models/transaction_model.dart';
import '../domain/budget_status.dart';
import 'providers.dart';

/// A category enriched with its derived spend/status — the spreadsheet's row.
class CategoryView {
  final CategoryModel category;
  final double spent;
  const CategoryView({required this.category, required this.spent});

  String get id => category.id;
  String get name => category.name;
  double get allocated => category.allocated;
  double get remaining => allocated - spent;
  double get ratio => allocated <= 0 ? 0 : spent / allocated;
  double get progress => ratio.clamp(0.0, 1.0);
  BudgetStatus get status => statusFor(allocated: allocated, ratio: ratio);
  double get suggested =>
      suggestBudget(allocated: allocated, spent: spent, status: status);
}

final currentMonthTransactionsProvider =
    Provider<List<TransactionModel>>((ref) {
  final monthId = ref.watch(settingsProvider).currentMonthId;
  final list = ref
      .watch(transactionsProvider)
      .where((t) => t.monthId == monthId)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
  return list;
});

final categoryViewsProvider = Provider<List<CategoryView>>((ref) {
  final cats = ref.watch(categoriesProvider);
  final txs = ref.watch(currentMonthTransactionsProvider);
  final spentByCat = <String, double>{};
  for (final t in txs) {
    spentByCat[t.categoryId] = (spentByCat[t.categoryId] ?? 0) + t.amount;
  }
  return [
    for (final c in cats)
      CategoryView(category: c, spent: spentByCat[c.id] ?? 0),
  ];
});

class BudgetSummary {
  final double opening;
  final double allocated;
  final double spent;
  const BudgetSummary({
    required this.opening,
    required this.allocated,
    required this.spent,
  });

  double get available => opening - spent; // current money available
  double get unallocated => opening - allocated;
  double get netCommitment => allocated - spent;
  double get commitmentRatio => allocated <= 0 ? 0 : spent / allocated;
}

final summaryProvider = Provider<BudgetSummary>((ref) {
  final s = ref.watch(settingsProvider);
  final views = ref.watch(categoryViewsProvider);
  double allocated = 0, spent = 0;
  for (final v in views) {
    allocated += v.allocated;
    spent += v.spent;
  }
  return BudgetSummary(
      opening: s.openingBalance, allocated: allocated, spent: spent);
});

class BudgetAnalytics {
  final int overCount;
  final int lowCount;
  final CategoryView? topSpender;
  final CategoryView? mostOver;
  final CategoryView? largestUnused;
  final double commitmentRatio;
  const BudgetAnalytics({
    required this.overCount,
    required this.lowCount,
    required this.topSpender,
    required this.mostOver,
    required this.largestUnused,
    required this.commitmentRatio,
  });

  bool get hasData => topSpender != null || overCount > 0 || lowCount > 0;
}

final analyticsProvider = Provider<BudgetAnalytics>((ref) {
  final views = ref.watch(categoryViewsProvider);
  final summary = ref.watch(summaryProvider);

  int overCount = 0, lowCount = 0;
  CategoryView? topSpender, mostOver, largestUnused;
  for (final v in views) {
    if (v.status == BudgetStatus.over) overCount++;
    if (v.status == BudgetStatus.low) lowCount++;
    if (v.spent > 0 && (topSpender == null || v.spent > topSpender.spent)) {
      topSpender = v;
    }
    if (v.status == BudgetStatus.over) {
      final over = v.spent - v.allocated;
      if (mostOver == null || over > (mostOver.spent - mostOver.allocated)) {
        mostOver = v;
      }
    }
    if (v.allocated > 0 && v.remaining > 0) {
      if (largestUnused == null || v.remaining > largestUnused.remaining) {
        largestUnused = v;
      }
    }
  }
  return BudgetAnalytics(
    overCount: overCount,
    lowCount: lowCount,
    topSpender: topSpender,
    mostOver: mostOver,
    largestUnused: largestUnused,
    commitmentRatio: summary.commitmentRatio,
  );
});

final localeProvider =
    Provider<Locale>((ref) => Locale(ref.watch(settingsProvider).localeCode));
