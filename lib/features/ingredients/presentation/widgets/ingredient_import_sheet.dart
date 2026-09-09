import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/feedback/app_toast.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/export/report_exporter.dart';
import '../../../../core/export/report_table.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sheet_scaffold.dart';
import '../../application/ingredient_providers.dart';
import '../../domain/ingredient_import_parser.dart';
import '../../domain/ingredient_import_row.dart';
import '../../domain/ingredient_unit_label.dart';

/// Impor massal bahan baku dari file Excel (update.md).
Future<void> showIngredientImportSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => const IngredientImportSheet(),
  );
}

class IngredientImportSheet extends ConsumerStatefulWidget {
  const IngredientImportSheet({super.key});

  @override
  ConsumerState<IngredientImportSheet> createState() =>
      _IngredientImportSheetState();
}

class _IngredientImportSheetState extends ConsumerState<IngredientImportSheet> {
  IngredientImportPreview? _preview;
  String? _fileName;
  bool _isBusy = false;
  String? _error;

  Future<void> _downloadTemplate() async {
    setState(() => _error = null);
    try {
      await ReportExporter.share(
        table: ReportTable(
          headers: kIngredientImportHeaders,
          rows: const [
            ['Durian', 'kg', 'Buah'],
            ['Gula Pasir', 'gram', 'Bumbu'],
            ['Cup 22oz', 'pcs', 'Kemasan'],
          ],
        ),
        fileNameWithoutExtension: 'template-impor-bahan-baku',
        format: ExportFormat.xlsx,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = friendlyErrorMessage(error));
    }
  }

  Future<void> _pickFile() async {
    setState(() {
      _isBusy = true;
      _error = null;
    });

    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      final path = picked?.path;
      if (path == null) return;

      final bytes = await File(path).readAsBytes();
      final existing = await ref
          .read(ingredientRepositoryProvider)
          .watchAll()
          .first;

      final preview = parseIngredientImport(
        bytes,
        existingNames: existing.map((item) => item.name).toSet(),
      );
      if (!mounted) return;
      setState(() {
        _preview = preview;
        _fileName = picked!.name;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = friendlyErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _import() async {
    final preview = _preview;
    if (preview == null || !preview.hasRows) return;

    setState(() {
      _isBusy = true;
      _error = null;
    });

    try {
      final inserted = await ref
          .read(ingredientRepositoryProvider)
          .importIngredients(preview.rows);
      if (!mounted) return;
      AppToast.success(context, '\$inserted bahan baku berhasil diimpor.');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$inserted bahan baku berhasil diimpor.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = friendlyErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;
    final theme = Theme.of(context);

    return SheetScaffold(
      title: 'Impor Bahan Baku',
      subtitle: 'Isi massal dari file Excel (.xlsx)',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Format File', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Tiga kolom berurutan: ${kIngredientImportHeaders.join(" · ")}. '
                    'Baris pertama boleh berupa judul kolom. Kategori boleh '
                    'dikosongkan, dan kategori baru akan dibuat otomatis.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Satuan bisa ditulis panjang ("Kilogram") atau singkat ("kg").',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: _isBusy ? null : _downloadTemplate,
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Unduh Template'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonalIcon(
            onPressed: _isBusy ? null : _pickFile,
            icon: const Icon(Icons.upload_file_outlined),
            label: Text(_fileName ?? 'Pilih File Excel'),
          ),
          if (preview != null) ...[
            const SizedBox(height: AppSpacing.md),
            _PreviewSummary(preview: preview),
          ],
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: (_isBusy || preview == null || !preview.hasRows)
                ? null
                : _import,
            child: _isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    preview == null
                        ? 'Impor'
                        : 'Impor ${preview.rows.length} Bahan',
                  ),
          ),
        ],
      ),
    );
  }
}

class _PreviewSummary extends StatelessWidget {
  const _PreviewSummary({required this.preview});

  final IngredientImportPreview preview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${preview.rows.length} baris siap diimpor'
          '${preview.hasIssues ? ', ${preview.issues.length} dilewati' : ''}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (preview.hasRows)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 160),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final row in preview.rows)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(row.name),
                    subtitle: Text(
                      [
                        row.unit.label,
                        if (row.categoryName != null) row.categoryName!,
                      ].join(' · '),
                    ),
                  ),
              ],
            ),
          ),
        if (preview.hasIssues) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Baris yang dilewati',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final issue in preview.issues)
            Text(
              issue.rowNumber == 0
                  ? issue.reason
                  : 'Baris ${issue.rowNumber}: ${issue.reason}',
              style: theme.textTheme.bodySmall,
            ),
        ],
      ],
    );
  }
}
