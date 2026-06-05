import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/derived_providers.dart';
import '../../../application/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/budget_status.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../sheets/category_sheet.dart';
import '../../widgets/common.dart';
import '../../widgets/status_style.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final views = ref.watch(categoryViewsProvider);
    final symbol = ref.watch(settingsProvider).currencySymbol;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          l.categoriesTitle,
          trailing: _AddButton(onTap: () => showCategorySheet(context)),
        ),
        if (views.isEmpty)
          AppCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(l.emptyCategories,
                    style: const TextStyle(color: Colors.black54)),
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, c) {
              const gap = 12.0;
              final cols = c.maxWidth >= 560 ? 3 : 2;
              final tileW = (c.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (int i = 0; i < views.length; i++)
                    SizedBox(
                      width: tileW,
                      child: CategoryTile(view: views[i], symbol: symbol)
                          .animate()
                          .fadeIn(delay: (40 * i).ms, duration: 360.ms)
                          .slideY(begin: 0.12, curve: Curves.easeOut),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.all(6),
          child: Icon(Icons.add_rounded, color: AppColors.primary),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final CategoryView view;
  final String symbol;
  const CategoryTile({super.key, required this.view, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final color = statusColor(view.status);
    final over = view.status.isOver;

    return AppCard(
      onTap: () => showCategorySheet(context, existing: view.category),
      padding: const EdgeInsets.all(14),
      border: over ? Border.all(color: AppColors.danger, width: 1.4) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(view.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
              ),
              if (over)
                const Icon(Icons.warning_amber_rounded,
                        color: AppColors.danger, size: 18)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(
                        begin: 0.85,
                        end: 1.12,
                        duration: 700.ms,
                        curve: Curves.easeInOut),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(view.allocated <= 0 ? '—' : Formatters.percent(view.ratio),
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w700, fontSize: 13)),
              Flexible(
                child: Text(statusLabel(view.status, l),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _ProgressBar(progress: view.progress, color: color),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(Formatters.money(view.spent, symbol),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: over ? AppColors.danger : null)),
              ),
              const SizedBox(width: 6),
              Text(Formatters.money(view.allocated, symbol),
                  style:
                      const TextStyle(color: Colors.black45, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  const _ProgressBar({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 8,
        color: const Color(0xFFECF3F1),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) => FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: v,
            child: Container(color: color),
          ),
        ),
      ),
    );
  }
}
