import '../core/constants/budget_constants.dart';

/// Category health, mirroring the spreadsheet's color tiers.
enum BudgetStatus { noBudget, low, within, near, over }

extension BudgetStatusX on BudgetStatus {
  bool get isOver => this == BudgetStatus.over;
}

/// Pure classification — no UI dependency.
BudgetStatus statusFor({required double allocated, required double ratio}) {
  if (allocated <= 0) return BudgetStatus.noBudget;
  if (ratio > BudgetConstants.overThreshold) return BudgetStatus.over;
  if (ratio >= BudgetConstants.nearThreshold) return BudgetStatus.near;
  if (ratio >= BudgetConstants.withinThreshold) return BudgetStatus.within;
  return BudgetStatus.low;
}

/// Suggested next-month budget from actual spend.
double suggestBudget({
  required double allocated,
  required double spent,
  required BudgetStatus status,
}) {
  double raw;
  switch (status) {
    case BudgetStatus.over:
      raw = spent * BudgetConstants.suggestOverFactor;
      break;
    case BudgetStatus.near:
    case BudgetStatus.within:
      raw = spent; // trim slack toward actual
      break;
    case BudgetStatus.low:
      raw = spent * BudgetConstants.suggestLowFactor;
      if (raw > allocated && allocated > 0) raw = allocated;
      break;
    case BudgetStatus.noBudget:
      raw = spent;
      break;
  }
  final step = BudgetConstants.roundStep;
  return (raw / step).ceil() * step;
}
