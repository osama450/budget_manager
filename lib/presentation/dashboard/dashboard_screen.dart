import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/gen/app_localizations.dart';
import '../history/history_screen.dart';
import '../sheets/currency_sheet.dart';
import '../sheets/new_month_sheet.dart';
import '../sheets/transaction_sheet.dart';
import 'widgets/analytics_section.dart';
import 'widgets/category_section.dart';
import 'widgets/summary_section.dart';
import 'widgets/transactions_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final localeCode = ref.watch(settingsProvider.select((s) => s.localeCode));

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(l.appTitle,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        actions: [
          TextButton.icon(
            onPressed: () => ref.read(settingsProvider.notifier).toggleLocale(),
            icon: const Icon(Icons.translate_rounded, size: 18),
            label: Text(localeCode == 'ar' ? 'EN' : 'ع',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
          IconButton(
            tooltip: l.currency,
            onPressed: () => showCurrencySheet(context),
            icon: const Icon(Icons.currency_exchange_rounded),
          ),
          IconButton(
            tooltip: l.history,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            tooltip: l.startNewMonth,
            onPressed: () => showNewMonthSheet(context),
            icon: const Icon(Icons.event_repeat_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTransactionSheet(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(l.addTransaction),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: const [
          SummarySection(),
          SizedBox(height: 22),
          CategoriesSection(),
          SizedBox(height: 22),
          AnalyticsSection(),
          SizedBox(height: 22),
          TransactionsSection(),
        ],
      ),
    );
  }
}
