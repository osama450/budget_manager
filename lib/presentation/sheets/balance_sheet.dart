import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../l10n/gen/app_localizations.dart';
import '../widgets/common.dart';

Future<void> showBalanceSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _BalanceSheet(),
  );
}

class _BalanceSheet extends ConsumerStatefulWidget {
  const _BalanceSheet();

  @override
  ConsumerState<_BalanceSheet> createState() => _BalanceSheetState();
}

class _BalanceSheetState extends ConsumerState<_BalanceSheet> {
  late final TextEditingController _amount;

  @override
  void initState() {
    super.initState();
    final current = ref.read(settingsProvider).openingBalance;
    _amount = TextEditingController(
        text: current > 0 ? trimAmount(current) : '');
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    final value = double.tryParse(_amount.text.trim()) ?? 0;
    ref.read(settingsProvider.notifier).setOpeningBalance(value);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SheetScaffold(
      title: l.setOpeningBalance,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _amount,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              labelText: l.openingBalance,
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: Text(l.save)),
        ],
      ),
    );
  }
}
