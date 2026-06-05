import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/derived_providers.dart';
import '../../../application/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/transaction_model.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../sheets/transaction_sheet.dart';
import '../../widgets/common.dart';

class TransactionsSection extends ConsumerWidget {
  const TransactionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final txs = ref.watch(currentMonthTransactionsProvider);
    final cats = ref.watch(categoriesProvider);
    final symbol = ref.watch(settingsProvider).currencySymbol;
    final locale = Localizations.localeOf(context).languageCode;
    final names = {for (final c in cats) c.id: c.name};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l.transactionsTitle),
        if (txs.isEmpty)
          AppCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(l.emptyTransactions,
                    style: const TextStyle(color: Colors.black54)),
              ),
            ),
          )
        else
          for (int i = 0; i < txs.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TransactionTile(
                tx: txs[i],
                categoryName: names[txs[i].categoryId] ?? '—',
                symbol: symbol,
                locale: locale,
              )
                  .animate()
                  .fadeIn(delay: (30 * i).ms, duration: 320.ms)
                  .slideX(begin: 0.06, curve: Curves.easeOut),
            ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  final String categoryName;
  final String symbol;
  final String locale;

  const _TransactionTile({
    required this.tx,
    required this.categoryName,
    required this.symbol,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final initial =
        categoryName.trim().isEmpty ? '?' : categoryName.trim().substring(0, 1);
    return AppCard(
      onTap: () => showTransactionSheet(context, existing: tx),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(initial,
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                if (tx.note != null && tx.note!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(tx.note!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 12)),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.money(tx.amount, symbol),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 2),
              Text(Formatters.dayMonth(tx.date, locale),
                  style:
                      const TextStyle(color: Colors.black45, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
