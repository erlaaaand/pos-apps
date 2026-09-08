import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/local/app_database.dart';
import '../application/ingredient_providers.dart';
import 'widgets/ingredient_unit_label.dart';

/// Create or edit an ingredient's name/unit. Stock and cost are never
/// editable here — they only ever change through [recordPurchase].
class IngredientFormScreen extends ConsumerStatefulWidget {
  const IngredientFormScreen({this.editing, super.key});

  /// When non-null, the form edits this ingredient instead of creating one.
  final Ingredient? editing;

  @override
  ConsumerState<IngredientFormScreen> createState() =>
      _IngredientFormScreenState();
}

class _IngredientFormScreenState extends ConsumerState<IngredientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late IngredientUnit _unit;
  bool _isSubmitting = false;
  String? _submitError;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editing?.name ?? '');
    _unit = widget.editing?.unit ?? IngredientUnit.gram;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final repository = ref.read(ingredientRepositoryProvider);
    try {
      if (_isEditing) {
        await repository.updateNameAndUnit(
          id: widget.editing!.id,
          name: _nameController.text.trim(),
          unit: _unit,
        );
      } else {
        await repository.create(
          name: _nameController.text.trim(),
          unit: _unit,
        );
      }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Ubah Bahan Baku' : 'Tambah Bahan Baku'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Bahan'),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama bahan wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<IngredientUnit>(
              initialValue: _unit,
              decoration: const InputDecoration(labelText: 'Satuan'),
              items: IngredientUnit.values
                  .map(
                    (unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _unit = value);
              },
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
