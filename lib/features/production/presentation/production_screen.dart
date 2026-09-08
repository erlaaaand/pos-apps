import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../ingredients/presentation/widgets/ingredient_unit_label.dart';
import '../application/production_providers.dart';
import '../domain/production_preview.dart';
import '../domain/session_cost_input.dart';

/// Proses produksi untuk satu PO yang sudah Tutup (B.3): tampilkan kebutuhan
/// bahan vs stok, biarkan pemilik pilih pesanan mana yang dimasak kalau
/// bahan kurang (default FIFO), lalu konfirmasi.
class ProductionScreen extends ConsumerStatefulWidget {
  const ProductionScreen({required this.purchaseOrderId, super.key});

  final int purchaseOrderId;

  @override
  ConsumerState<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends ConsumerState<ProductionScreen> {
  Set<int>? _selectedOrderIds;
  final _costNameController = TextEditingController(text: 'Gas');
  final _costAmountController = TextEditingController();
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void dispose() {
    _costNameController.dispose();
    _costAmountController.dispose();
    super.dispose();
  }

  Future<void> _confirm(ProductionPreview preview) async {
    final selected = _selectedOrderIds ?? preview.suggestedOrderIdsToCook.toSet();
    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final costAmount = int.tryParse(_costAmountController.text);
    final sessionCosts = <SessionCostInput>[
      if (_costNameController.text.trim().isNotEmpty && costAmount != null && costAmount > 0)
        SessionCostInput(
          name: _costNameController.text.trim(),
          amountRupiah: costAmount,
        ),
    ];

    try {
      await ref
          .read(productionRepositoryProvider)
          .confirmCook(
            purchaseOrderId: widget.purchaseOrderId,
            orderIdsToCook: selected.toList(),
            sessionCosts: sessionCosts,
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
    final previewAsync = ref.watch(
      productionPreviewProvider(widget.purchaseOrderId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Proses Produksi')),
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(friendlyErrorMessage(error))),
        data: (preview) {
          if (preview.waitingOrders.isEmpty) {
            return const EmptyState(
              message: 'Tidak ada pesanan menunggu produksi di PO ini.',
            );
          }

          final selected =
              _selectedOrderIds ?? preview.suggestedOrderIdsToCook.toSet();

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (!preview.isSufficient) ...[
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bahan tidak cukup untuk semua pesanan',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        for (final shortfall in preview.shortfalls)
                          Text(
                            '${shortfall.ingredientName}: butuh '
                            '${_fmt(shortfall.needed)} ${shortfall.unit.shortLabel}, '
                            'stok ${_fmt(shortfall.available)} '
                            '${shortfall.unit.shortLabel} '
                            '(kurang ${_fmt(shortfall.shortBy)})',
                          ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Pesanan tercentang di bawah (default FIFO) akan '
                          'dimasak. Sisanya otomatis dibatalkan dengan alasan '
                          '"bahan baku tidak cukup" — centang/hapus centang '
                          'untuk mengubah pilihan.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              Text(
                'Pesanan (${selected.length}/${preview.waitingOrders.length} dipilih)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final detail in preview.waitingOrders)
                CheckboxListTile(
                  value: selected.contains(detail.order.id),
                  title: Text('${detail.productName} × ${detail.order.quantity}'),
                  subtitle: Text(
                    '${detail.order.orderedAt.hour.toString().padLeft(2, '0')}:'
                    '${detail.order.orderedAt.minute.toString().padLeft(2, '0')}'
                    '${detail.order.buyerContact != null ? ' · ${detail.order.buyerContact}' : ''}',
                  ),
                  onChanged: (value) {
                    setState(() {
                      final next = Set<int>.from(selected);
                      if (value ?? false) {
                        next.add(detail.order.id);
                      } else {
                        next.remove(detail.order.id);
                      }
                      _selectedOrderIds = next;
                    });
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Biaya Resource Sesi Ini',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _costNameController,
                      decoration: const InputDecoration(labelText: 'Nama Biaya'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _costAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah (Rp)',
                        prefixText: 'Rp ',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
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
                // An empty selection is allowed to proceed — it means none
                // of the waiting orders fit the available stock, so
                // confirming cancels all of them and still moves the PO to
                // Selesai Masak instead of leaving it stuck.
                onPressed: _isSubmitting ? null : () => _confirm(preview),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        selected.isEmpty
                            ? 'Batalkan Semua & Konfirmasi'
                            : 'Konfirmasi Selesai Masak',
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _fmt(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }
}
