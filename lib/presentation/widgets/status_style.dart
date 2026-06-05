import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/budget_status.dart';
import '../../l10n/gen/app_localizations.dart';

Color statusColor(BudgetStatus status) {
  switch (status) {
    case BudgetStatus.low:
      return AppColors.statusLow;
    case BudgetStatus.within:
      return AppColors.statusWithin;
    case BudgetStatus.near:
      return AppColors.statusNear;
    case BudgetStatus.over:
      return AppColors.statusOver;
    case BudgetStatus.noBudget:
      return AppColors.statusNeutral;
  }
}

String statusLabel(BudgetStatus status, AppLocalizations l) {
  switch (status) {
    case BudgetStatus.low:
      return l.statusLow;
    case BudgetStatus.within:
      return l.statusWithin;
    case BudgetStatus.near:
      return l.statusNear;
    case BudgetStatus.over:
      return l.statusOver;
    case BudgetStatus.noBudget:
      return l.statusNoBudget;
  }
}
