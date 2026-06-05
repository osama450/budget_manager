import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/derived_providers.dart';
import '../../../application/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../sheets/balance_sheet.dart';
import '../../widgets/common.dart';

class SummarySection extends ConsumerWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(settingsProvider);
    final summary = ref.watch(summaryProvider);
    final symbol = s.currencySymbol;
    final overspent = summary.available < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          color: AppColors.primary,
          onTap: () => showBalanceSheet(context),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.available,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14)),
                  ),
                  const Icon(Icons.edit_outlined,
                      color: Colors.white54, size: 18),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                Formatters.money(summary.available, symbol),
                style: TextStyle(
                  color: overspent ? const Color(0xFFFFD6D3) : Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Container(height: 1, color: Colors.white24),
              const SizedBox(height: 14),
              Row(
                children: [
                  _heroStat(l.openingBalance,
                      Formatters.money(summary.opening, symbol)),
                  _heroStat(
                      l.allocated, Formatters.money(summary.allocated, symbol)),
                  _heroStat(l.spent, Formatters.money(summary.spent, symbol)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, curve: Curves.easeOut),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MiniStat(
                  label: l.unallocated,
                  value: Formatters.money(summary.unallocated, symbol)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniStat(
                  label: l.netCommitment,
                  value: Formatters.money(summary.netCommitment, symbol)),
            ),
          ],
        ).animate().fadeIn(delay: 80.ms, duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOut),
      ],
    );
  }

  Widget _heroStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 11)),
          const SizedBox(height: 3),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
