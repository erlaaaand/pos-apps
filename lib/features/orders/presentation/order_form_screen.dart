import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_searchable_dropdown.dart';
import '../../products/application/product_providers.dart';
import '../application/order_providers.dart';

/// Catat pesanan masuk dari WhatsApp (B.2), ditautkan ke satu PO yang Buka.
class OrderFormScreen extends ConsumerStatefulWidget {
  const OrderFormScreen({required this.purchaseOrderId, super.key});

  final int purchaseOrderId;

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  final _contactController = TextEditingController();
  final _noteController = TextEditingController();
  int? _productId;
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void dispose() {
    _quantityController.dispose();
    _contactController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await ref
          .read(orderRepositoryProvider)
          .create(
            purchaseOrderId: widget.purchaseOrderId,
            productId: _productId!,
            quantity: int.parse(_quantityController.text),
            buyerContact: _contactController.text.trim().isEmpty
                ? null
                : _contactController.text.trim(),
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
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
    final productsAsync = ref.watch(productsWithActiveRecipeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pesanan')),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(friendlyErrorMessage(error))),
        data: (products) {
          final activeProducts = products
              .where((entry) => entry.product.isActive)
              .toList();

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                AppSearchableDropdown<int>(
                  label: 'Produk',
                  hintText: 'Pilih produk',
                  searchHint: 'Cari produk...',
                  value: _productId,
                  options: [
                    for (final entry in activeProducts)
                      AppDropdownOption(
                        value: entry.product.id,
                        label: entry.product.name,
                        subtitle: RupiahFormatter.format(
                          entry.recipe.sellingPriceRupiah,
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() => _productId = value),
                  validator: (value) => value == null ? 'Pilih produk' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Qty'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    return (parsed == null || parsed <= 0) ? 'Qty > 0' : null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Kontak Pembeli (opsional)',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (opsional)',
                  ),
                ),
                if (_submitError != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _submitError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
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
                      : const Text('Simpan Pesanan'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
