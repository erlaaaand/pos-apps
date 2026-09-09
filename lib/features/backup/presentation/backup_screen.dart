import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/database_provider.dart';
import '../application/backup_providers.dart';

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  Future<void> _backupNow(BuildContext context, WidgetRef ref) async {
    final format = await showDialog<BackupFormat>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Backup Sekarang'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(BackupFormat.db),
            child: const ListTile(
              title: Text('Salinan .db (disarankan)'),
              subtitle: Text(
                'Format utama, paling reliable untuk restore penuh',
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(BackupFormat.sql),
            child: const ListTile(
              title: Text('Dump .sql (opsional)'),
              subtitle: Text('Bisa dibaca manual / untuk migrasi nanti'),
            ),
          ),
        ],
      ),
    );
    if (format == null) return;
    if (!context.mounted) return;

    try {
      final repository = ref.read(backupRepositoryProvider);
      final log = format == BackupFormat.db
          ? await repository.backupAsDb(trigger: BackupTrigger.manual)
          : await repository.backupAsSql(trigger: BackupTrigger.manual);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Backup berhasil dibuat.')));
      await repository.shareBackup(log);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(friendlyErrorMessage(error))));
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['db', 'sqlite', 'sql'],
    );
    final pickedPath = picked?.path;
    if (pickedPath == null) return;
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pulihkan dari Backup?'),
        content: Text(
          'Semua data yang ada sekarang akan DITIMPA oleh isi file '
          '"${picked!.name}". Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Timpa & Pulihkan'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;

    try {
      await ref.read(backupRepositoryProvider).restoreFromFile(pickedPath);
      // The live connection was closed as part of restoring; force every
      // repository depending on it to rebuild against the restored file.
      ref.invalidate(appDatabaseProvider);
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Restore Berhasil'),
          content: const Text(
            'Data sudah dipulihkan. Tutup dan buka ulang aplikasi supaya '
            'semua layar memuat data yang baru.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(friendlyErrorMessage(error))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(backupHistoryProvider);
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          FilledButton.icon(
            onPressed: () => _backupNow(context, ref),
            icon: const Icon(Icons.backup_outlined),
            label: const Text('Backup Sekarang'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => _restore(context, ref),
            icon: const Icon(Icons.restore_outlined),
            label: const Text('Pulihkan dari File'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Riwayat Backup',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          AsyncValueView(
            value: historyAsync,
            onRetry: () => ref.invalidate(backupHistoryProvider),
            data: (context, logs) {
              if (logs.isEmpty) {
                return const EmptyState(message: 'Belum ada backup.');
              }
              return Column(
                children: logs
                    .map(
                      (log) => Card(
                        child: ListTile(
                          leading: Icon(
                            log.format == BackupFormat.db
                                ? Icons.storage_outlined
                                : Icons.description_outlined,
                          ),
                          title: Text(dateFormat.format(log.createdAt)),
                          subtitle: Text(
                            '${log.format == BackupFormat.db ? '.db' : '.sql'} · '
                            '${log.trigger == BackupTrigger.manual ? 'Manual' : 'Otomatis (tutup hari)'}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.share_outlined),
                            tooltip: 'Bagikan',
                            onPressed: () => ref
                                .read(backupRepositoryProvider)
                                .shareBackup(log),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
