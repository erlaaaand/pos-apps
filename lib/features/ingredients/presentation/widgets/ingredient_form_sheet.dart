import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/feedback/app_toast.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_searchable_dropdown.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../../../data/local/app_database.dart';
import '../../application/ingredient_providers.dart';
import '../../domain/ingredient_unit_label.dart';

/// Membuka form tambah/ubah bahan baku sebagai bottom sheet (update.md:14 —
/// tidak lagi pindah halaman penuh).
Future<void> showIngredientFormSheet(
  BuildContext context, {
  Ingredient? editing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => IngredientFormSheet(editing: editing),
  );
}

class IngredientFormSheet extends ConsumerStatefulWidget {
  const IngredientFormSheet({this.editing, super.key});

  final Ingredient? editing;

  @override
  ConsumerState<IngredientFormSheet> createState() =>
      _IngredientFormSheetState();
}

class _IngredientFormSheetState extends ConsumerState<IngredientFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late IngredientUnit _unit;
  int? _categoryId;
  bool _isSubmitting = false;
  String? _submitError;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.editing?.name ?? '');
    _unit = widget.editing?.unit ?? IngredientUnit.gram;
    _categoryId = widget.editing?.categoryId;
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
        await repository.updateDetails(
          id: widget.editing!.id,
          name: _nameController.text.trim(),
          unit: _unit,
          categoryId: _categoryId,
        );
      } else {
        await repository.create(
          name: _nameController.text.trim(),
          unit: _unit,
          categoryId: _categoryId,
        );
      }
      if (!mounted) return;
      AppToast.success(
        context,
        _isEditing ? 'Bahan baku diperbarui.' : 'Bahan baku ditambahkan.',
      );
      Navigator.of(context).pop();
    } catch (error) {
      setState(() => _submitError = friendlyErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _createCategory() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _NewCategoryDialog(),
    );
    if (name == null || name.trim().isEmpty) return;

    try {
      final id = await ref
          .read(ingredientRepositoryProvider)
          .createCategory(name);
      if (!mounted) return;
      setState(() => _categoryId = id);
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitError = friendlyErrorMessage(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(ingredientCategoriesProvider);

    return SheetScaffold(
      title: _isEditing ? 'Ubah Bahan Baku' : 'Tambah Bahan Baku',
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nama Bahan'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Nama bahan wajib diisi'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppSearchableDropdown<IngredientUnit>(
              label: 'Satuan',
              searchHint: 'Cari satuan (mis. gram, sdm, cup)...',
              value: _unit,
              options: _unitOptions(),
              onChanged: (value) => setState(() => _unit = value),
            ),
            const SizedBox(height: AppSpacing.md),
            categories.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const SizedBox.shrink(),
              data: (items) => Row(
                children: [
                  Expanded(
                    child: AppSearchableDropdown<int?>(
                      label: 'Kategori (opsional)',
                      searchHint: 'Cari kategori...',
                      value: _categoryId,
                      options: [
                        const AppDropdownOption<int?>(
                          value: null,
                          label: 'Tanpa kategori',
                          keywords: ['kosong', 'none'],
                        ),
                        for (final category in items)
                          AppDropdownOption<int?>(
                            value: category.id,
                            label: category.name,
                          ),
                      ],
                      onChanged: (value) => setState(() => _categoryId = value),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filledTonal(
                    onPressed: _createCategory,
                    tooltip: 'Kategori baru',
                    icon: const Icon(Icons.add),
                  ),
                ],
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

  /// 18 satuan, masing-masing membawa nama kelompoknya sebagai subjudul.
  ///
  /// Judul kelompok tidak lagi jadi baris terpisah seperti pada dropdown lama:
  /// dengan kolom pencarian, nama kelompok justru lebih berguna sebagai kata
  /// kunci — mengetik "takaran" memunculkan sdt/sdm/gelas sekaligus.
  List<AppDropdownOption<IngredientUnit>> _unitOptions() {
    return [
      for (final group in IngredientUnitGroup.values)
        for (final unit in group.units)
          AppDropdownOption(
            value: unit,
            label: unit.label,
            subtitle: group.label,
            keywords: [unit.shortLabel, unit.name, group.label],
          ),
    ];
  }
}

class _NewCategoryDialog extends StatefulWidget {
  const _NewCategoryDialog();

  @override
  State<_NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<_NewCategoryDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kategori Baru'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(labelText: 'Nama kategori'),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
