import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/feedback/app_toast.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/settings_providers.dart';

/// Tombol pemilih mode tampilan untuk header beranda.
///
/// Tiga pilihan disajikan lewat sheet, bukan satu tombol yang berputar antar
/// mode: dengan tiga keadaan, tombol berputar membuat pengguna harus menekan
/// berulang kali sambil menebak urutannya.
class ThemeModeButton extends ConsumerWidget {
  const ThemeModeButton({this.foregroundColor, super.key});

  /// Warna ikon. Header beranda berlatar gradien, jadi warnanya diatur dari
  /// luar alih-alih mengikuti `colorScheme`.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref
        .watch(themeModeProvider)
        .maybeWhen(data: (value) => value, orElse: () => ThemeMode.system);

    return IconButton(
      icon: Icon(_iconFor(mode), color: foregroundColor),
      tooltip: 'Mode tampilan: ${_labelFor(mode)}',
      onPressed: () => _openPicker(context, ref, mode),
    );
  }

  static IconData _iconFor(ThemeMode mode) => switch (mode) {
    ThemeMode.light => Icons.light_mode_outlined,
    ThemeMode.dark => Icons.dark_mode_outlined,
    ThemeMode.system => Icons.brightness_auto_outlined,
  };

  static String _labelFor(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'Terang',
    ThemeMode.dark => 'Gelap',
    ThemeMode.system => 'Ikut HP',
  };

  static String _descriptionFor(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'Selalu tampilan terang.',
    ThemeMode.dark => 'Selalu tampilan gelap, lebih nyaman saat malam.',
    ThemeMode.system => 'Mengikuti setelan tampilan HP.',
  };

  Future<void> _openPicker(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) async {
    final picked = await showModalBottomSheet<ThemeMode>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.compact),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(sheetContext).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                'Mode Tampilan',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
            ),
            RadioGroup<ThemeMode>(
              groupValue: current,
              onChanged: (value) => Navigator.of(sheetContext).pop(value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final mode in ThemeMode.values)
                    RadioListTile<ThemeMode>(
                      value: mode,
                      title: Text(_labelFor(mode)),
                      subtitle: Text(_descriptionFor(mode)),
                      secondary: Icon(_iconFor(mode)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );

    if (picked == null || picked == current) return;

    await ref.read(settingsRepositoryProvider).setThemeMode(picked);
    if (!context.mounted) return;
    AppToast.success(context, 'Mode tampilan: ${_labelFor(picked)}.');
  }
}
