import 'dart:io';

import 'package:budget_manager/data/budget_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('bm_test');
    Hive.init(dir.path);
  });

  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  test('seeds 8 default categories on first run', () async {
    final repo =
        await BudgetRepository.open(initialLocale: 'en', useFlutterInit: false);
    expect(repo.getCategories().length, 8);
  });

  test('transaction round-trips and feeds category spend', () async {
    final repo =
        await BudgetRepository.open(initialLocale: 'en', useFlutterInit: false);
    final cat = repo.getCategories().first;
    repo.updateCategory(cat.copyWith(allocated: 500));
    repo.addTransaction(categoryId: cat.id, amount: 200, date: DateTime(2026, 6, 1));

    final txs = repo.getTransactions();
    expect(txs.length, 1);
    expect(txs.first.amount, 200);
    expect(txs.first.categoryId, cat.id);
  });

  test('startNewMonth archives the cycle and rolls leftover into balance',
      () async {
    final repo =
        await BudgetRepository.open(initialLocale: 'en', useFlutterInit: false);
    repo.saveSettings(repo.getSettings().copyWith(openingBalance: 1000));
    final cat = repo.getCategories().first;
    repo.addTransaction(categoryId: cat.id, amount: 200, date: DateTime(2026, 6, 1));

    final before = repo.getSettings();
    final after = repo.startNewMonth();

    // leftover (1000 - 200) becomes the new opening balance
    expect(after.openingBalance, 800);
    // month advanced
    expect(after.currentMonthId, isNot(before.currentMonthId));
    // archived with the right totals
    final archived = repo.getArchivedMonths();
    expect(archived.length, 1);
    expect(archived.first.totalSpent, 200);
    expect(archived.first.remaining, 800);
    // categories survive the reset; new cycle has no transactions yet
    expect(repo.getCategories().length, 8);
    expect(
      repo.getTransactions().where((t) => t.monthId == after.currentMonthId).length,
      0,
    );
  });

  test('deleting a category removes its transactions', () async {
    final repo =
        await BudgetRepository.open(initialLocale: 'en', useFlutterInit: false);
    final cat = repo.getCategories().first;
    repo.addTransaction(categoryId: cat.id, amount: 50, date: DateTime(2026, 6, 1));
    expect(repo.getTransactions().length, 1);

    repo.deleteCategory(cat.id);
    expect(repo.getCategories().length, 7);
    expect(repo.getTransactions().length, 0);
  });
}
