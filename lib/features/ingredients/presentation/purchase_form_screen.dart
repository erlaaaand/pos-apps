import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/local/app_database.dart';
import '../application/ingredient_providers.dart';
import 'widgets/ingredient_unit_label.dart';

/// Records a purchase for [ingredient] (A.2). Stock and weighted-average
/// cost are recalculated automatically by the repository on submit — this
/// screen never edits them directly.
class PurchaseFormScreen extends ConsumerStatefulWidget {
  const PurchaseFormScreen({required this.ingredient, super.key});

  final Ingredient ingredient;

  @override
  ConsumerState<PurchaseFormScreen> createState() =>
      _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends ConsumerState<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _storeController = TextEditingController();
  DateTime _purchasedAt = DateTime.now();
  bool _isSubmitting = false;
  String? _submitError;

  double? get _quantity => double.tryParse(_quantityController.text);
  int? get _totalPrice => int.tryParse(_totalPriceController.text);

  @override
  void dispose() {
    _quantityController.dispose();
    _totalPriceController.dispose();
    _storeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchasedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _purchasedAt = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await ref
          .read(ingredientRepositoryProvider)
          .recordPurchase(
            ingredientId: widget.ingredient.id,
            quantity: _quantity!,
            totalPriceRupiah: _totalPrice!,
            storeName: _storeController.text.trim().isEmpty
                ? null
                : _storeController.text.trim(),
            purchasedAt: _purchasedAt,
          );
      if (!mounted) return;
      context.pop();
    } catch (error) {
      setState(() => _submitError = friendlyErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quantity = _quantity;
    final totalPrice = _totalPrice;
    final perUnitPreview = (quantity != null && quantity > 0 && totalPrice != null)
        ? totalPrice / quantity
        : null;

    return Scaffold(
      appBar: AppBar(title: Text('Catat Pembelian: ${widget.ingredient.name}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Qty Dibeli (${widget.ingredient.unit.shortLabel})',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (_) => setState(() {}),
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Qty harus lebih dari 0';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _totalPriceController,
              decoration: const InputDecoration(
                labelText: 'Total Harga (Rp)',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Total harga harus lebih dari 0';
                }
                return null;
              },
            ),
            if (perUnitPreview != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                '≈ ${RupiahFormatter.format(perUnitPreview.round())} / '
                '${widget.ingredient.unit.shortLabel}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _storeController,
              decoration: const InputDecoration(
                labelText: 'Nama Toko/Pasar (opsional)',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Tanggal Beli'),
              subtitle: Text(
                '${_purchasedAt.day}/${_purchasedAt.month}/${_purchasedAt.year}',
              ),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
            if (_submitError != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                _submitError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan Pembelian'),
            ),
          ],
        ),
      ),
    );
  }
}
