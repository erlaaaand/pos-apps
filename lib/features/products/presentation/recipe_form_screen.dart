import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/local/app_database.dart';
import '../../ingredients/application/ingredient_providers.dart';
import '../application/product_providers.dart';
import '../domain/recipe_item_detail.dart';
import '../domain/recipe_item_input.dart';
import 'widgets/recipe_item_editor_row.dart';

/// Arguments for [RecipeFormScreen] navigation. When [existingProduct] is
/// null the form creates a new product + its first recipe; otherwise it adds
/// a new recipe version for that product ("Tambah Resep Baru" per erp.md
/// A.3 — same form either way), optionally pre-filled from the current
/// recipe so the owner only edits what's changing.
class RecipeFormArgs {
  const RecipeFormArgs({this.existingProduct, this.prefillItems, this.prefillSellingPriceRupiah});

  final Product? existingProduct;
  final List<RecipeItemDetail>? prefillItems;
  final int? prefillSellingPriceRupiah;
}

class RecipeFormScreen extends ConsumerStatefulWidget {
  const RecipeFormScreen({this.args = const RecipeFormArgs(), super.key});

  final RecipeFormArgs args;

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  final List<RecipeItemRowState> _rows = [];
  bool _isSubmitting = false;
  String? _submitError;

  bool get _isNewProduct => widget.args.existingProduct == null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.args.existingProduct?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.args.prefillSellingPriceRupiah?.toString() ?? '',
    );

    final prefill = widget.args.prefillItems;
    if (prefill != null && prefill.isNotEmpty) {
      for (final item in prefill) {
        _rows.add(
          RecipeItemRowState(
            ingredientId: item.ingredientId,
            initialQuantity: item.quantityPerBatch,
          ),
        );
      }
    } else {
      _rows.add(RecipeItemRowState());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow() => setState(() => _rows.add(RecipeItemRowState()));

  void _removeRow(RecipeItemRowState row) {
    setState(() {
      _rows.remove(row);
      row.dispose();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final items = <RecipeItemInput>[];
    for (final row in _rows) {
      final ingredientId = row.ingredientId;
      final quantity = double.tryParse(row.quantityController.text);
      if (ingredientId == null || quantity == null || quantity <= 0) continue;
      items.add(
        RecipeItemInput(ingredientId: ingredientId, quantityPerBatch: quantity),
      );
    }

    if (items.isEmpty) {
      setState(() => _submitError = 'Resep harus punya minimal 1 bahan baku.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final repository = ref.read(recipeRepositoryProvider);
    final sellingPrice = int.parse(_priceController.text);
    try {
      if (_isNewProduct) {
        await repository.createProduct(
          name: _nameController.text.trim(),
          sellingPriceRupiah: sellingPrice,
          items: items,
        );
      } else {
        await repository.addRecipeVersion(
          productId: widget.args.existingProduct!.id,
          sellingPriceRupiah: sellingPrice,
          items: items,
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
    final ingredientsAsync = ref.watch(ingredientListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNewProduct ? 'Tambah Produk' : 'Tambah Resep Baru'),
      ),
      body: ingredientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(friendlyErrorMessage(error))),
        data: (ingredients) {
          if (ingredients.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Belum ada bahan baku terdaftar. Tambahkan bahan baku '
                      'dulu di Master Bahan Baku sebelum membuat resep.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton(
                      onPressed: () => context.push('/ingredients/new'),
                      child: const Text('Tambah Bahan Baku'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                if (_isNewProduct)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Nama produk wajib diisi'
                        : null,
                  )
                else
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Produk'),
                    subtitle: Text(widget.args.existingProduct!.name),
                  ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Harga Jual (Rp)',
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final parsed = int.tryParse(value ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Harga jual harus lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Bahan & Takaran per Batch',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final row in _rows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: RecipeItemEditorRow(
                      row: row,
                      ingredients: ingredients,
                      onRemove: _rows.length > 1 ? () => _removeRow(row) : null,
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: _addRow,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Bahan'),
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
                      : const Text('Simpan Resep'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
