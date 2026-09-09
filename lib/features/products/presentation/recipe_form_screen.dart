import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/feedback/app_toast.dart';
import '../../../core/money/rupiah_formatter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/local/app_database.dart';
import '../../ingredients/application/ingredient_providers.dart';
import '../../ingredients/domain/ingredient_unit_label.dart';
import '../application/product_providers.dart';
import '../domain/recipe_item_detail.dart';
import '../domain/recipe_item_input.dart';
import 'widgets/recipe_item_editor_row.dart';

/// Parameter navigasi untuk [RecipeFormScreen].
class RecipeFormArgs {
  const RecipeFormArgs({
    this.existingProduct,
    this.prefillItems,
    this.prefillSellingPriceRupiah,
  });

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
    final prefillPrice = widget.args.prefillSellingPriceRupiah;
    _priceController = TextEditingController(
      text: (prefillPrice == null || prefillPrice == 0)
          ? ''
          : prefillPrice.toString(),
    );

    final prefill = widget.args.prefillItems;
    if (prefill != null && prefill.isNotEmpty) {
      for (final item in prefill) {
        _rows.add(
          RecipeItemRowState(
            ingredientId: item.ingredientId,
            initialQuantity: item.quantityPerBatch,
            customUnit: item.unit,
            kind: item.kind,
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

  void _addRow(RecipeItemKind kind) =>
      setState(() => _rows.add(RecipeItemRowState(kind: kind)));

  List<RecipeItemRowState> _rowsOf(RecipeItemKind kind) =>
      _rows.where((row) => row.kind == kind).toList();

  void _removeRow(RecipeItemRowState row) {
    setState(() {
      _rows.remove(row);
      row.dispose();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredientsList =
        ref.read(ingredientListProvider).asData?.value ?? [];

    final items = <RecipeItemInput>[];
    for (final row in _rows) {
      final ingredientId = row.ingredientId;
      final quantity = double.tryParse(row.quantityController.text);
      if (ingredientId == null || quantity == null || quantity <= 0) continue;

      final ingredient = ingredientsList.firstWhere(
        (i) => i.id == ingredientId,
      );
      final fromUnit = row.customUnit ?? ingredient.unit;

      // Konversi kuantitas kustom (misal g/sdt/sdm) ke kuantitas satuan dasar bahan
      final baseQuantity = convertQuantityToBaseUnit(
        quantity,
        fromUnit,
        ingredient.unit,
      );

      items.add(
        RecipeItemInput(
          ingredientId: ingredientId,
          quantityPerBatch: baseQuantity,
          kind: row.kind,
        ),
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
    final sellingPrice = int.tryParse(_priceController.text.trim()) ?? 0;
    try {
      if (_isNewProduct) {
        await repository.createProduct(
          name: _nameController.text.trim(),
          items: items,
          sellingPriceRupiah: sellingPrice,
        );
      } else {
        await repository.addRecipeVersion(
          productId: widget.args.existingProduct!.id,
          items: items,
          sellingPriceRupiah: sellingPrice,
        );
      }
      if (!mounted) return;
      AppToast.success(
        context,
        _isNewProduct ? 'Produk berhasil dibuat.' : 'Resep baru tersimpan.',
      );
      context.pop();
    } catch (error) {
      setState(() => _submitError = friendlyErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  /// Estimasi HPP dari baris yang sedang diisi, memakai harga modal bahan
  /// yang berlaku sekarang. Dihitung ulang tiap ketikan supaya pemilik
  /// langsung lihat untung/ruginya sebelum menyimpan.
  int _estimatedHpp(List<Ingredient> ingredients) {
    var total = 0.0;
    for (final row in _rows) {
      final ingredientId = row.ingredientId;
      final quantity = double.tryParse(row.quantityController.text);
      if (ingredientId == null || quantity == null || quantity <= 0) continue;

      final match = ingredients.where((i) => i.id == ingredientId);
      if (match.isEmpty) continue;
      final ingredient = match.first;

      final baseQuantity = convertQuantityToBaseUnit(
        quantity,
        row.customUnit ?? ingredient.unit,
        ingredient.unit,
      );
      total += baseQuantity * ingredient.currentCostPerUnit;
    }
    return total.round();
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
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
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
                    labelText: 'Harga Jual per Porsi',
                    prefixText: 'Rp ',
                    helperText: 'Harga yang dibayar pembeli untuk 1 porsi.',
                  ),
                  keyboardType: TextInputType.number,
                  // Harga ikut terkunci ke versi resep ini, jadi tiap revisi
                  // resep memang wajib menyebut harganya sendiri.
                  validator: (value) {
                    final raw = value?.trim() ?? '';
                    if (raw.isEmpty) return 'Harga jual wajib diisi';
                    final parsed = int.tryParse(raw);
                    if (parsed == null) return 'Harga jual harus berupa angka';
                    if (parsed <= 0) return 'Harga jual harus lebih dari 0';
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),

                _MarginPreview(
                  sellingPriceRupiah:
                      int.tryParse(_priceController.text.trim()) ?? 0,
                  hppRupiah: _estimatedHpp(ingredients),
                ),
                const SizedBox(height: AppSpacing.md),

                // Info Banner Perencanaan Takaran per Porsi
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Takaran resep diinput per 1 Porsi. Takaran ini digunakan oleh sistem '
                          'untuk menghitung kebutuhan bahan dan perencanaan belanja (planning) berdasarkan stok yang tersedia.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Section Bahan Baku
                _RecipeSection(
                  title: 'Bahan Baku (Takaran per 1 Porsi)',
                  emptyHint: 'Belum ada bahan baku pada resep ini.',
                  addLabel: 'Tambah Bahan',
                  rows: _rowsOf(RecipeItemKind.ingredient),
                  ingredients: ingredients,
                  onAdd: () => _addRow(RecipeItemKind.ingredient),
                  onRemove: _removeRow,
                  canRemove: _rows.length > 1,
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Section Kemasan
                _RecipeSection(
                  title: 'Kemasan (Per 1 Porsi)',
                  emptyHint:
                      'Belum ada kemasan. Cup, sendok, dan sejenisnya bisa '
                      'ditambahkan di sini.',
                  addLabel: 'Tambah Kemasan',
                  rows: _rowsOf(RecipeItemKind.packaging),
                  ingredients: ingredients,
                  onAdd: () => _addRow(RecipeItemKind.packaging),
                  onRemove: _removeRow,
                  canRemove: _rows.length > 1,
                  onChanged: () => setState(() {}),
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

/// Ringkasan untung/rugi per porsi sementara resep masih diisi.
///
/// Semua angka di sini boleh nol, jadi tiap pembagian dijaga: persentase
/// margin hanya dihitung kalau harga jual > 0, dan HPP nol dilaporkan sebagai
/// "belum ada harga modal" — bukan sebagai untung 100%, karena yang terjadi
/// sebenarnya adalah bahannya belum pernah dibeli.
class _MarginPreview extends StatelessWidget {
  const _MarginPreview({
    required this.sellingPriceRupiah,
    required this.hppRupiah,
  });

  final int sellingPriceRupiah;
  final int hppRupiah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final margin = sellingPriceRupiah - hppRupiah;
    final hasPrice = sellingPriceRupiah > 0;
    final percent = hasPrice ? (margin / sellingPriceRupiah) * 100 : null;

    final (Color tone, String headline, String detail) = switch (null) {
      _ when hppRupiah == 0 => (
        AppColors.warning,
        'HPP belum bisa dihitung',
        'Bahan pada resep ini belum punya harga modal. Catat pembelian '
            'bahannya dulu supaya margin akurat.',
      ),
      _ when !hasPrice => (
        AppColors.info,
        'Isi harga jual',
        'HPP per porsi ${RupiahFormatter.format(hppRupiah)}. Masukkan harga '
            'jual untuk melihat marginnya.',
      ),
      _ when margin < 0 => (
        AppColors.danger,
        'Rugi ${RupiahFormatter.format(margin.abs())} per porsi',
        'Harga jual di bawah HPP ${RupiahFormatter.format(hppRupiah)}.',
      ),
      _ when margin == 0 => (
        AppColors.warning,
        'Impas, tanpa untung',
        'Harga jual persis sama dengan HPP ${RupiahFormatter.format(hppRupiah)}.',
      ),
      _ => (
        AppColors.success,
        'Untung ${RupiahFormatter.format(margin)} per porsi',
        'HPP ${RupiahFormatter.format(hppRupiah)} · Margin '
            '${percent!.toStringAsFixed(1)}%',
      ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: tone.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.calculate_outlined, color: tone, size: 20),
          const SizedBox(width: AppSpacing.compact),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: tone,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(detail, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeSection extends StatelessWidget {
  const _RecipeSection({
    required this.title,
    required this.emptyHint,
    required this.addLabel,
    required this.rows,
    required this.ingredients,
    required this.onAdd,
    required this.onRemove,
    required this.canRemove,
    required this.onChanged,
  });

  final String title;
  final String emptyHint;
  final String addLabel;
  final List<RecipeItemRowState> rows;
  final List<Ingredient> ingredients;
  final VoidCallback onAdd;
  final void Function(RecipeItemRowState row) onRemove;
  final bool canRemove;

  /// Diteruskan ke tiap baris supaya estimasi HPP di atas ikut diperbarui.
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              emptyHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: RecipeItemEditorRow(
              row: row,
              ingredients: ingredients,
              onRemove: canRemove ? () => onRemove(row) : null,
              onChanged: onChanged,
            ),
          ),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: Text(addLabel),
        ),
      ],
    );
  }
}
