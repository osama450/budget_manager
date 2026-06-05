import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/transaction_model.dart';
import '../../l10n/gen/app_localizations.dart';
import '../widgets/common.dart';

Future<void> showTransactionSheet(
  BuildContext context, {
  TransactionModel? existing,
  String? presetCategoryId,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) =>
        _TransactionSheet(existing: existing, presetCategoryId: presetCategoryId),
  );
}

class _TransactionSheet extends ConsumerStatefulWidget {
  final TransactionModel? existing;
  final String? presetCategoryId;
  const _TransactionSheet({this.existing, this.presetCategoryId});

  @override
  ConsumerState<_TransactionSheet> createState() => _TransactionSheetState();
}

class _TransactionSheetState extends ConsumerState<_TransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount = TextEditingController(
      text: widget.existing != null ? trimAmount(widget.existing!.amount) : '');
  late final TextEditingController _note =
      TextEditingController(text: widget.existing?.note ?? '');
  String? _categoryId;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.existing?.categoryId ?? widget.presetCategoryId;
    _date = widget.existing?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) return;
    final amount = double.parse(_amount.text.trim());
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();
    final n = ref.read(transactionsProvider.notifier);
    if (widget.existing == null) {
      n.add(categoryId: _categoryId!, amount: amount, date: _date, note: note);
    } else {
      n.update(widget.existing!.copyWith(
          categoryId: _categoryId, amount: amount, date: _date, note: note));
    }
    Navigator.pop(context);
  }

  void _confirmDelete() {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        content: Text(l.deleteTransactionConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx), child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              ref
                  .read(transactionsProvider.notifier)
                  .remove(widget.existing!.id);
              Navigator.pop(dctx);
              Navigator.pop(context);
            },
            child:
                Text(l.delete, style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cats = ref.watch(categoriesProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final editing = widget.existing != null;

    if (cats.isEmpty) {
      return SheetScaffold(
        title: l.addTransaction,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(l.emptyCategories, textAlign: TextAlign.center),
        ),
      );
    }

    final ids = cats.map((c) => c.id).toSet();
    final selected = (_categoryId != null && ids.contains(_categoryId))
        ? _categoryId
        : null;

    return SheetScaffold(
      title: editing ? l.editTransaction : l.addTransaction,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amount,
              autofocus: !editing,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: l.amount,
                prefixIcon: const Icon(Icons.payments_outlined),
              ),
              validator: (v) {
                final d = double.tryParse((v ?? '').trim());
                return (d == null || d <= 0) ? l.invalidAmount : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selected,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l.selectCategory,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: [
                for (final c in cats)
                  DropdownMenuItem(
                    value: c.id,
                    child: Text(c.name, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (v) => setState(() => _categoryId = v),
              validator: (v) => v == null ? l.requiredField : null,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l.date,
                  prefixIcon: const Icon(Icons.event_outlined),
                ),
                child: Text(Formatters.fullDate(_date, locale)),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _note,
              decoration: InputDecoration(
                labelText: l.note,
                prefixIcon: const Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (editing) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l.delete),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: AppColors.danger),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: FilledButton(onPressed: _save, child: Text(l.save)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
