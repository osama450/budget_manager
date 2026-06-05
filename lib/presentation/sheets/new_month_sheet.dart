import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/derived_providers.dart';
import '../../application/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/gen/app_localizations.dart';
import '../widgets/common.dart';

Future<void> showNewMonthSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _NewMonthSheet(),
  );
}

class _NewMonthSheet extends ConsumerWidget {
  const _NewMonthSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final s = ref.watch(settingsProvider);
    final summary = ref.watch(summaryProvider);
    final symbol = s.currencySymbol;
    final monthLabel = Formatters.monthLabel(s.currentMonthId, s.localeCode);
    final remaining = summary.available;

    return SheetScaffold(
      title: l.startNewMonth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _row(l.spent, Formatters.money(summary.spent, symbol)),
                const SizedBox(height: 10),
                _row(l.available, Formatters.money(remaining, symbol),
                    bold: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.newMonthExplain(monthLabel, Formatters.money(remaining, symbol)),
            style: const TextStyle(color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              final messenger = ScaffoldMessenger.of(context);
              ref.read(settingsProvider.notifier).startNewMonth();
              Navigator.pop(context);
              messenger.showSnackBar(
                SnackBar(content: Text(l.startNewMonth)),
              );
            },
            icon: const Icon(Icons.event_repeat_rounded),
            label: Text(l.confirm),
          ),
        ],
      ),
    );
  }

  Widget _row(String a, String b, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(a, style: const TextStyle(color: Colors.black54)),
        Text(b,
            style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                fontSize: bold ? 18 : 14,
                color: bold ? AppColors.primary : null)),
      ],
    );
  }
}
