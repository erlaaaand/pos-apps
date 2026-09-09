import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../../../data/local/app_database.dart';
import '../../application/finance_providers.dart';

Future<void> showCapitalEntrySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => const CapitalEntrySheet(),
  );
}

class CapitalEntrySheet extends ConsumerStatefulWidget {
  const CapitalEntrySheet({super.key});

  @override
  ConsumerState<CapitalEntrySheet> createState() => _CapitalEntrySheetState();
}

class _CapitalEntrySheetState extends ConsumerState<CapitalEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  CapitalEntryKind _kind = CapitalEntryKind.initial;
  final DateTime _recordedAt = DateTime.now();
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final rawAmount = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(rawAmount) ?? 0;
    if (amount <= 0) {
      setState(() => _submitError = 'Nominal harus lebih dari 0');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await ref
          .read(financeRepositoryProvider)
          .addCapitalEntry(
            kind: _kind,
            amountRupiah: amount,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            recordedAt: _recordedAt,
          );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(() => _submitError = friendlyErrorMessage(error));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Tambah Catatan Modal / Alat',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<CapitalEntryKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Jenis Entri'),
              items: const [
                DropdownMenuItem(
                  value: CapitalEntryKind.initial,
                  child: Text('Modal Masuk / Modal Awal'),
                ),
                DropdownMenuItem(
                  value: CapitalEntryKind.injection,
                  child: Text('Suntikan Modal Tambahan'),
                ),
                DropdownMenuItem(
                  value: CapitalEntryKind.equipment,
                  child: Text('Investasi Alat / Perlengkapan'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _kind = val);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal (Rp)',
                prefixText: 'Rp ',
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Nominal wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Catatan / Keterangan (opsional)',
                hintText: 'Misal: Pembelian Blender, Modal Tambahan',
              ),
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
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
