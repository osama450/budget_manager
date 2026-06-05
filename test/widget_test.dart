import 'package:budget_manager/application/derived_providers.dart';
import 'package:budget_manager/domain/budget_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('statusFor', () {
    test('no allocation -> noBudget', () {
      expect(statusFor(allocated: 0, ratio: 0), BudgetStatus.noBudget);
    });
    test('low / within / near / over tiers (spreadsheet samples)', () {
      expect(statusFor(allocated: 500, ratio: 0.40), BudgetStatus.low);
      expect(statusFor(allocated: 3000, ratio: 0.50), BudgetStatus.within);
      expect(statusFor(allocated: 5000, ratio: 1.00), BudgetStatus.near);
      expect(statusFor(allocated: 800, ratio: 1.0625), BudgetStatus.over);
    });
  });

  group('suggestBudget', () {
    test('over budget adds a buffer, rounded up to 10', () {
      expect(
        suggestBudget(allocated: 800, spent: 850, status: BudgetStatus.over),
        900,
      );
    });
    test('within rate trims toward actual spend', () {
      expect(
        suggestBudget(
            allocated: 3000, spent: 1750, status: BudgetStatus.within),
        1750,
      );
    });
    test('low use trims toward spend, capped below allocation', () {
      expect(
        suggestBudget(allocated: 600, spent: 250, status: BudgetStatus.low),
        280,
      );
    });
  });

  group('BudgetSummary', () {
    const s = BudgetSummary(opening: 15000, allocated: 12100, spent: 9320);
    test('derived figures match the dashboard formulas', () {
      expect(s.available, 15000 - 9320); // 5680
      expect(s.unallocated, 15000 - 12100); // 2900
      expect(s.netCommitment, 12100 - 9320); // 2780
      expect((s.commitmentRatio * 10000).round(), 7702); // 9320/12100
    });
  });
}
