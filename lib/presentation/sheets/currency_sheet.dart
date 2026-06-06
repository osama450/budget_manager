import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/gen/app_localizations.dart';
import '../widgets/common.dart';

const List<(String, String)> _presets = [
  ('ج.م', 'EGP'),
  ('ر.س', 'SAR'),
  ('د.إ', 'AED'),
  ('د.ك', 'KWD'),
  (r'$', 'USD'),
  ('€', 'EUR'),
  ('£', 'GBP'),
  ('₺', 'TRY'),
];

Future<void> showCurrencySheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _CurrencySheet(),
  );
}

class _CurrencySheet extends ConsumerStatefulWidget {
  const _CurrencySheet();

  @override
  ConsumerState<_CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends ConsumerState<_CurrencySheet> {
  final _custom = TextEditingController();

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  void _apply(String symbol) {
    final value = symbol.trim();
    if (value.isEmpty) return;
    ref.read(settingsProvider.notifier).setCurrency(value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final current = ref.watch(settingsProvider).currencySymbol;

    return SheetScaffold(
      title: l.currency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _presets)
                ChoiceChip(
                  selected: p.$1 == current,
                  label: Text('${p.$1}  ${p.$2}'),
                  showCheckmark: false,
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: p.$1 == current ? AppColors.primary : null,
                  ),
                  onSelected: (_) => _apply(p.$1),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _custom,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: l.custom,
                    hintText: current,
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                  ),
                  onSubmitted: _apply,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () => _apply(_custom.text),
                child: Text(l.save),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
