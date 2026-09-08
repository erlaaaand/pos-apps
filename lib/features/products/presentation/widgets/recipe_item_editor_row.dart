import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/local/app_database.dart';
import '../../../ingredients/presentation/widgets/ingredient_unit_label.dart';

/// Mutable form state for one BOM row in [RecipeFormScreen]. Owns its own
/// [TextEditingController] so callers must call [dispose] when the row is
/// removed or the form is disposed.
class RecipeItemRowState {
  RecipeItemRowState({this.ingredientId, double? initialQuantity})
    : quantityController = TextEditingController(
        text: initialQuantity == null ? '' : _trimZero(initialQuantity),
      );

  int? ingredientId;
  final TextEditingController quantityController;

  void dispose() => quantityController.dispose();

  static String _trimZero(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toString();
  }
}

/// One editable BOM line: ingredient picker + quantity, with an optional
/// remove button.
class RecipeItemEditorRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    String? selectedUnit;
    for (final ingredient in ingredients) {
      if (ingredient.id == row.ingredientId) {
        selectedUnit = ingredient.unit.shortLabel;
        break;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<int>(
            initialValue: row.ingredientId,
            decoration: const InputDecoration(labelText: 'Bahan'),
            items: ingredients
                .map(
                  (ingredient) => DropdownMenuItem(
                    value: ingredient.id,
                    child: Text(ingredient.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (value) => row.ingredientId = value,
            validator: (value) => value == null ? 'Pilih bahan' : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: row.quantityController,
            decoration: InputDecoration(
              labelText: 'Qty${selectedUnit != null ? ' ($selectedUnit)' : ''}',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            validator: (value) {
              final parsed = double.tryParse(value ?? '');
              if (parsed == null || parsed <= 0) return 'Qty > 0';
              return null;
            },
          ),
        ),
        if (onRemove != null)
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            tooltip: 'Hapus bahan ini',
            onPressed: onRemove,
          ),
      ],
    );
  }
}
