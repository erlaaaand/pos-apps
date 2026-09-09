import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/widgets/app_searchable_dropdown.dart';
import '../../../../data/local/app_database.dart';
import '../../../ingredients/domain/ingredient_unit_label.dart';

/// State formulir mutable untuk satu baris takaran resep (BOM) di [RecipeFormScreen].
class RecipeItemRowState {
  RecipeItemRowState({
    this.ingredientId,
    double? initialQuantity,
    this.customUnit,
    this.kind = RecipeItemKind.ingredient,
  }) : quantityController = TextEditingController(
         text: initialQuantity == null ? '' : _trimZero(initialQuantity),
       );

  int? ingredientId;
  IngredientUnit? customUnit;
  final TextEditingController quantityController;

  /// Baris ini masuk bagian Bahan Baku atau Kemasan.
  final RecipeItemKind kind;

  void dispose() => quantityController.dispose();

  static String _trimZero(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toString();
  }
}

/// Satu baris takaran resep per porsi: pemilih bahan baku + qty per porsi + satuan takaran kustom.
class RecipeItemEditorRow extends StatefulWidget {
  const RecipeItemEditorRow({
    required this.row,
    required this.ingredients,
    required this.onRemove,
    this.onChanged,
    super.key,
  });

  final RecipeItemRowState row;
  final List<Ingredient> ingredients;
  final VoidCallback? onRemove;

  /// Dipanggil tiap baris berubah, supaya form induk bisa menghitung ulang
  /// estimasi HPP-nya.
  final VoidCallback? onChanged;

  @override
  State<RecipeItemEditorRow> createState() => _RecipeItemEditorRowState();
}

class _RecipeItemEditorRowState extends State<RecipeItemEditorRow> {
  @override
  Widget build(BuildContext context) {
    Ingredient? selectedIngredient;
    for (final ingredient in widget.ingredients) {
      if (ingredient.id == widget.row.ingredientId) {
        selectedIngredient = ingredient;
        break;
      }
    }

    // Default satuan ke satuan dasar bahan jika belum dipilih
    if (selectedIngredient != null && widget.row.customUnit == null) {
      widget.row.customUnit = selectedIngredient.unit;
    }

    final currentUnit =
        widget.row.customUnit ??
        selectedIngredient?.unit ??
        IngredientUnit.gram;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Pemilih Bahan
        Expanded(
          flex: 4,
          child: AppSearchableDropdown<int>(
            label: 'Bahan',
            hintText: 'Pilih bahan',
            searchHint: 'Cari bahan baku...',
            isDense: true,
            value: widget.row.ingredientId,
            options: [
              for (final ingredient in widget.ingredients)
                AppDropdownOption(
                  value: ingredient.id,
                  label: ingredient.name,
                  subtitle: ingredient.unit.label,
                  keywords: [ingredient.unit.shortLabel],
                ),
            ],
            onChanged: (value) {
              setState(() {
                widget.row.ingredientId = value;
                final picked = widget.ingredients.firstWhere(
                  (i) => i.id == value,
                );
                widget.row.customUnit = picked.unit;
              });
              widget.onChanged?.call();
            },
            validator: (value) => value == null ? 'Pilih bahan' : null,
          ),
        ),
        const SizedBox(width: 6),

        // 2. Input Qty Per Porsi
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: widget.row.quantityController,
            decoration: const InputDecoration(
              labelText: 'Qty / Porsi',
              hintText: '0.0',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            validator: (value) {
              final parsed = double.tryParse(value ?? '');
              if (parsed == null || parsed <= 0) return '> 0';
              return null;
            },
            onChanged: (_) => widget.onChanged?.call(),
          ),
        ),
        const SizedBox(width: 6),

        // 3. Dropdown Satuan Takaran Kustom
        Expanded(
          flex: 3,
          child: AppSearchableDropdown<IngredientUnit>(
            label: 'Satuan',
            searchHint: 'Cari satuan...',
            isDense: true,
            value: currentUnit,
            options: [
              for (final unit in IngredientUnit.values)
                AppDropdownOption(
                  value: unit,
                  label: unit.shortLabel,
                  subtitle: unit.label,
                  keywords: [unit.name],
                ),
            ],
            onChanged: (unit) {
              setState(() => widget.row.customUnit = unit);
              widget.onChanged?.call();
            },
          ),
        ),

        if (widget.onRemove != null)
          IconButton(
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Colors.redAccent,
            ),
            tooltip: 'Hapus bahan ini',
            onPressed: widget.onRemove,
          ),
      ],
    );
  }
}
