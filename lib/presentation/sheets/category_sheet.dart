import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/category_model.dart';
import '../../l10n/gen/app_localizations.dart';
import '../widgets/common.dart';

Future<void> showCategorySheet(BuildContext context, {CategoryModel? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _CategorySheet(existing: existing),
  );
}

class _CategorySheet extends ConsumerStatefulWidget {
  final CategoryModel? existing;
  const _CategorySheet({this.existing});

  @override
  ConsumerState<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends ConsumerState<_CategorySheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _amount = TextEditingController(
    text: (widget.existing != null && widget.existing!.allocated > 0)
        ? trimAmount(widget.existing!.allocated)
        : '',
  );

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final name = _name.text.trim();
    final allocated = double.tryParse(_amount.text.trim()) ?? 0;
    final notifier = ref.read(categoriesProvider.notifier);
    if (widget.existing == null) {
      notifier.add(name, allocated);
    } else {
      notifier.update(
          widget.existing!.copyWith(name: name, allocated: allocated));
    }
    Navigator.of(context).pop();
  }

  void _confirmDelete() {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        content: Text(l.deleteCategoryConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx), child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              ref.read(categoriesProvider.notifier).remove(widget.existing!.id);
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
    final editing = widget.existing != null;
    return SheetScaffold(
      title: editing ? l.editCategory : l.addCategory,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l.categoryName,
                prefixIcon: const Icon(Icons.label_outline_rounded),
              ),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return l.requiredField;
                final dup = ref.read(categoriesProvider).any((c) =>
                    c.id != widget.existing?.id &&
                    c.name.trim().toLowerCase() == t.toLowerCase());
                return dup ? l.duplicateName : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: l.budgetLimit,
                prefixIcon: const Icon(Icons.savings_outlined),
              ),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return null; // 0 / no-budget allowed
                return double.tryParse(t) == null ? l.invalidAmount : null;
              },
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
