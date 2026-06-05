import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/derived_providers.dart';
import '../../../application/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../widgets/common.dart';

class AnalyticsSection extends ConsumerWidget {
  const AnalyticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final views = ref.watch(categoryViewsProvider);
    final a = ref.watch(analyticsProvider);
    final symbol = ref.watch(settingsProvider).currencySymbol;

    if (views.isEmpty) return const SizedBox.shrink();

    final chips = <Widget>[
      _chip(
          icon: Icons.error_outline_rounded,
          value: '${a.overCount}',
          label: l.overBudgetLabel,
          color: AppColors.danger),
      _chip(
          icon: Icons.eco_outlined,
          value: '${a.lowCount}',
          label: l.lowUseLabel,
          color: AppColors.statusLow),
      if (a.topSpender != null)
        _chip(
            icon: Icons.trending_up_rounded,
            value: a.topSpender!.name,
            label: l.topSpender,
            color: AppColors.primary),
      if (a.mostOver != null)
        _chip(
            icon: Icons.priority_high_rounded,
            value: a.mostOver!.name,
            label: l.mostOver,
            color: AppColors.statusNear),
      if (a.largestUnused != null)
        _chip(
            icon: Icons.savings_outlined,
            value: a.largestUnused!.name,
            label: l.largestUnused,
            color: AppColors.statusWithin),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(l.analyticsTitle),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.commitmentRatio,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 13)),
                  ),
                  Text(Formatters.percent(a.commitmentRatio),
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 8,
                  color: const Color(0xFFECF3F1),
                  child: FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: a.commitmentRatio.clamp(0.0, 1.0),
                    child: Container(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 8, children: chips),
              const Divider(height: 28),
              Text(l.suggestedForNextMonth,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 10),
              ...views.map((v) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(v.name,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        Text(Formatters.money(v.allocated, symbol),
                            style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 14, color: Colors.black38),
                        ),
                        Text(Formatters.money(v.suggested, symbol),
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                      ],
                    ),
                  )),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () => _confirmApply(context, ref, views),
                icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                label: Text(l.applySuggested),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, curve: Curves.easeOut),
      ],
    );
  }

  void _confirmApply(
      BuildContext context, WidgetRef ref, List<CategoryView> views) {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        content: Text(l.suggestedForNextMonth),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              final byId = {for (final v in views) v.id: v.suggested};
              ref.read(categoriesProvider.notifier).applyAllocations(byId);
              Navigator.pop(dctx);
              messenger.showSnackBar(
                  SnackBar(content: Text(l.applySuggested)));
            },
            child: Text(l.confirm),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 180),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
