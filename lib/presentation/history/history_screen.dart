import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/archived_month.dart';
import '../../l10n/gen/app_localizations.dart';
import '../widgets/common.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final months = ref.watch(archivedMonthsProvider);
    final s = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.archivedMonths)),
      body: months.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l.noHistory,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: months.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _MonthCard(
                month: months[i],
                symbol: s.currencySymbol,
                locale: s.localeCode,
              ),
            ),
    );
  }
}

class _MonthCard extends StatefulWidget {
  final ArchivedMonth month;
  final String symbol;
  final String locale;
  const _MonthCard({
    required this.month,
    required this.symbol,
    required this.locale,
  });

  @override
  State<_MonthCard> createState() => _MonthCardState();
}

class _MonthCardState extends State<_MonthCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final m = widget.month;
    return AppCard(
      onTap: () => setState(() => _open = !_open),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(Formatters.monthLabel(m.id, widget.locale),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              Text(l.transactionCount(m.transactionCount),
                  style: const TextStyle(color: Colors.black45, fontSize: 12)),
              Icon(_open
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _stat(l.spent, Formatters.money(m.totalSpent, widget.symbol)),
              _stat(l.available, Formatters.money(m.remaining, widget.symbol)),
              _stat(l.allocated,
                  Formatters.money(m.totalAllocated, widget.symbol)),
            ],
          ),
          if (_open) ...[
            const Divider(height: 28),
            ...m.categories.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(c.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      '${Formatters.money(c.spent, widget.symbol)} / ${Formatters.money(c.allocated, widget.symbol)}',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 11)),
          const SizedBox(height: 3),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
