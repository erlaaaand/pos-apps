import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../products/application/product_providers.dart';
import '../application/purchase_order_providers.dart';
import '../domain/po_quota_input.dart';

class _QuotaRowState {
  _QuotaRowState() : quantityController = TextEditingController();

  int? productId;
  final TextEditingController quantityController;

  void dispose() => quantityController.dispose();
}

/// Bikin PO baru (B.1): label + jam buka + kuota per produk aktif.
class PurchaseOrderFormScreen extends ConsumerStatefulWidget {
  const PurchaseOrderFormScreen({super.key});

  @override
  ConsumerState<PurchaseOrderFormScreen> createState() =>
      _PurchaseOrderFormScreenState();
}

class _PurchaseOrderFormScreenState
    extends ConsumerState<PurchaseOrderFormScreen> {
  static const _suggestedLabels = ['Pagi', 'Siang', 'Sore', 'Malam'];

  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final List<_QuotaRowState> _rows = [_QuotaRowState()];
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void dispose() {
    _labelController.dispose();
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final quotas = <PoQuotaInput>[];
    for (final row in _rows) {
      final productId = row.productId;
      final quantity = int.tryParse(row.quantityController.text);
      if (productId == null || quantity == null || quantity <= 0) continue;
      quotas.add(PoQuotaInput(productId: productId, quotaQuantity: quantity));
    }

    if (quotas.isEmpty) {
      setState(() => _submitError = 'Isi kuota minimal 1 produk.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await ref
          .read(purchaseOrderRepositoryProvider)
          .create(label: _labelController.text.trim(), quotas: quotas);
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
      appBar: AppBar(title: const Text('Buat PO')),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(friendlyErrorMessage(error))),
        data: (products) {
          final activeProducts = products
              .where((entry) => entry.product.isActive)
              .map((entry) => entry.product)
              .toList();

          if (activeProducts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Belum ada produk aktif. Tambahkan produk dulu di menu Produk.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                TextFormField(
                  controller: _labelController,
                  decoration: const InputDecoration(labelText: 'Label PO'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Label wajib diisi'
                      : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: _suggestedLabels
                      .map(
                        (label) => ActionChip(
                          label: Text(label),
                          onPressed: () => _labelController.text = label,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Kuota per Produk',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final row in _rows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<int>(
                            initialValue: row.productId,
                            decoration: const InputDecoration(labelText: 'Produk'),
                            items: activeProducts
                                .map(
                                  (product) => DropdownMenuItem(
                                    value: product.id,
                                    child: Text(
                                      product.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => row.productId = value,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: row.quantityController,
                            decoration: const InputDecoration(labelText: 'Kuota'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        if (_rows.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => setState(() {
                              _rows.remove(row);
                              row.dispose();
                            }),
                          ),
                      ],
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _rows.add(_QuotaRowState())),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Produk'),
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
                      : const Text('Buat PO'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
