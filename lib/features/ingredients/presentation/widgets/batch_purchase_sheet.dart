import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/money/rupiah_formatter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../../../data/local/app_database.dart';
import '../../application/ingredient_providers.dart';
import '../../domain/batch_purchase_line_input.dart';
import '../../domain/cost_allocation.dart';
import '../../domain/ingredient_unit_label.dart';

/// Catat satu kali belanja yang bisa mencakup beberapa bahan sekaligus
/// (new_flow.md A.2 "pembelian borongan", update.md "pencatatan harian").
Future<void> showBatchPurchaseSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => const BatchPurchaseSheet(),
  );
}

class BatchPurchaseSheet extends ConsumerStatefulWidget {
  const BatchPurchaseSheet({super.key});

  @override
  ConsumerState<BatchPurchaseSheet> createState() => _BatchPurchaseSheetState();
}

class _BatchLineState {
  _BatchLineState();

  int? ingredientId;
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController allocationController = TextEditingController();

  /// Sekali pemilik mengubah alokasi baris ini, aplikasi berhenti menimpanya
  /// otomatis — kecuali tombol "Bagi Rata" ditekan.
  bool allocationEdited = false;

  void dispose() {
    quantityController.dispose();
    allocationController.dispose();
  }
}

class _BatchPurchaseSheetState extends ConsumerState<BatchPurchaseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _totalPriceController = TextEditingController();
  final _storeController = TextEditingController();
  final List<_BatchLineState> _lines = [_BatchLineState()];
  DateTime _purchasedAt = DateTime.now();
  bool _isSubmitting = false;
  String? _submitError;

  int get _totalPrice => int.tryParse(_totalPriceController.text) ?? 0;

  int get _allocatedTotal => _lines.fold<int>(
    0,
    (sum, line) => sum + (int.tryParse(line.allocationController.text) ?? 0),
  );

  bool get _anyManualAllocation => _lines.any((line) => line.allocationEdited);

  @override
  void dispose() {
    _totalPriceController.dispose();
    _storeController.dispose();
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  /// Isi ulang alokasi baris yang belum diubah manual. Dipanggil setiap total
  /// atau jumlah baris berubah, supaya angka default selalu pas.
  void _recomputeAllocations({bool force = false}) {
    final total = _totalPrice;
    if (total <= 0 || _lines.isEmpty) return;
    if (_anyManualAllocation && !force) return;

    final shares = allocateEvenly(
      totalPriceRupiah: total,
      lineCount: _lines.length,
    );
    for (var i = 0; i < _lines.length; i++) {
      _lines[i].allocationController.text = shares[i].toString();
      if (force) _lines[i].allocationEdited = false;
    }
  }

  void _addLine() {
    setState(() {
      _lines.add(_BatchLineState());
      _recomputeAllocations(force: !_anyManualAllocation);
    });
  }

  void _removeLine(_BatchLineState line) {
    setState(() {
      _lines.remove(line);
      line.dispose();
      _recomputeAllocations(force: !_anyManualAllocation);
    });
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

    final lines = <BatchPurchaseLineInput>[];
    for (final line in _lines) {
      final ingredientId = line.ingredientId;
      final quantity = double.tryParse(line.quantityController.text);
      final allocation = int.tryParse(line.allocationController.text);
      if (ingredientId == null || quantity == null || allocation == null) {
        setState(
          () => _submitError = 'Lengkapi bahan, qty, dan biaya tiap baris.',
        );
        return;
      }
      lines.add(
        BatchPurchaseLineInput(
          ingredientId: ingredientId,
          quantity: quantity,
          allocatedPriceRupiah: allocation,
        ),
      );
    }

    final duplicateIds = <int>{};
    for (final line in lines) {
      if (!duplicateIds.add(line.ingredientId)) {
        setState(
          () => _submitError = 'Ada bahan yang dipilih lebih dari sekali.',
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await ref
          .read(ingredientRepositoryProvider)
          .recordBatchPurchase(
            purchasedAt: _purchasedAt,
            storeName: _storeController.text.trim().isEmpty
                ? null
                : _storeController.text.trim(),
            totalPriceRupiah: _totalPrice,
            lines: lines,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      setState(() => _submitError = friendlyErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = ref.watch(ingredientListProvider);
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    final total = _totalPrice;
    final allocated = _allocatedTotal;
    final difference = total - allocated;

    return SheetScaffold(
      title: 'Belanja Bahan',
      subtitle: 'Satu kali belanja, bisa beberapa bahan sekaligus',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _totalPriceController,
              decoration: const InputDecoration(
                labelText: 'Total Dibayar',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(_recomputeAllocations),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Total belanja harus lebih dari 0';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _storeController,
              decoration: const InputDecoration(
                labelText: 'Nama Toko/Pasar (opsional)',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Tanggal Belanja'),
              subtitle: Text(dateFormat.format(_purchasedAt)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
            const Divider(height: AppSpacing.lg),
            Text(
              'Bahan yang Dibeli',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            ingredients.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(friendlyErrorMessage(error)),
              data: (available) {
                if (available.isEmpty) {
                  return const Text(
                    'Belum ada bahan baku terdaftar. Tambah bahan dulu '
                    'sebelum mencatat belanja.',
                  );
                }
                return Column(
                  children: [
                    for (final line in _lines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _BatchLineRow(
                          line: line,
                          ingredients: available,
                          onChanged: () => setState(() {}),
                          onRemove: _lines.length == 1
                              ? null
                              : () => _removeLine(line),
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _addLine,
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Bahan'),
                      ),
                    ),
                  ],
                );
              },
            ),
            if (total > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              _AllocationSummary(
                total: total,
                allocated: allocated,
                difference: difference,
                onSplitEvenly: () =>
                    setState(() => _recomputeAllocations(force: true)),
              ),
            ],
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
                  : const Text('Simpan Belanja'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BatchLineRow extends StatelessWidget {
  const _BatchLineRow({
    required this.line,
    required this.ingredients,
    required this.onChanged,
    required this.onRemove,
  });

  final _BatchLineState line;
  final List<Ingredient> ingredients;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final selected = ingredients
        .where((ingredient) => ingredient.id == line.ingredientId)
        .firstOrNull;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<int>(
                initialValue: line.ingredientId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Bahan'),
                items: [
                  for (final ingredient in ingredients)
                    DropdownMenuItem(
                      value: ingredient.id,
                      child: Text(
                        ingredient.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) {
                  line.ingredientId = value;
                  onChanged();
                },
                validator: (value) => value == null ? 'Pilih bahan' : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: line.quantityController,
                decoration: InputDecoration(
                  labelText: 'Qty',
                  suffixText: selected?.unit.shortLabel,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) return 'Qty?';
                  return null;
                },
              ),
            ),
            if (onRemove != null)
              IconButton(
                onPressed: onRemove,
                tooltip: 'Hapus baris',
                icon: const Icon(Icons.close),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: line.allocationController,
          decoration: const InputDecoration(
            labelText: 'Biaya bahan ini',
            prefixText: 'Rp ',
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) {
            line.allocationEdited = true;
            onChanged();
          },
          validator: (value) {
            final parsed = int.tryParse(value ?? '');
            if (parsed == null || parsed <= 0) {
              return 'Biaya harus lebih dari 0';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _AllocationSummary extends StatelessWidget {
  const _AllocationSummary({
    required this.total,
    required this.allocated,
    required this.difference,
    required this.onSplitEvenly,
  });

  final int total;
  final int allocated;
  final int difference;
  final VoidCallback onSplitEvenly;

  @override
  Widget build(BuildContext context) {
    final isBalanced = difference == 0;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            isBalanced
                ? 'Teralokasi pas: ${RupiahFormatter.format(allocated)}'
                : 'Teralokasi ${RupiahFormatter.format(allocated)} dari '
                      '${RupiahFormatter.format(total)} '
                      '(${difference > 0 ? 'kurang' : 'lebih'} '
                      '${RupiahFormatter.format(difference.abs())})',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isBalanced
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.error,
            ),
          ),
        ),
        TextButton(onPressed: onSplitEvenly, child: const Text('Bagi Rata')),
      ],
    );
  }
}
