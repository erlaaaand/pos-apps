import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    super.key,
  });

  final RecipeItemRowState row;
  final List<Ingredient> ingredients;
  final VoidCallback? onRemove;

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
          child: DropdownButtonFormField<int>(
            initialValue: widget.row.ingredientId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Bahan',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
            items: widget.ingredients
                .map(
                  (ingredient) => DropdownMenuItem(
                    value: ingredient.id,
                    child: Text(
                      ingredient.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                widget.row.ingredientId = value;
                final picked = widget.ingredients.firstWhere(
                  (i) => i.id == value,
                );
                widget.row.customUnit = picked.unit;
              });
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
          ),
        ),
        const SizedBox(width: 6),

        // 3. Dropdown Satuan Takaran Kustom
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<IngredientUnit>(
            initialValue: currentUnit,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Satuan',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
            items: IngredientUnit.values
                .map(
                  (unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(
                      unit.shortLabel,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (unit) {
              if (unit != null) {
                setState(() => widget.row.customUnit = unit);
              }
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
