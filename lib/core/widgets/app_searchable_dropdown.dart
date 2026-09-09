import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Satu pilihan di dalam [AppSearchableDropdown].
///
/// [keywords] menampung istilah alternatif yang tidak tampil di layar tapi
/// tetap bisa dicari — misal singkatan satuan ("sdm") untuk "Sendok Makan",
/// supaya pengguna tidak perlu tahu ejaan resminya.
class AppDropdownOption<T> {
  const AppDropdownOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.keywords = const [],
  });

  final T value;
  final String label;
  final String? subtitle;
  final List<String> keywords;

  /// Cocok kalau potongan kata muncul di label, subjudul, atau kata kunci.
  bool matches(String query) {
    if (query.isEmpty) return true;
    final needle = query.toLowerCase();
    if (label.toLowerCase().contains(needle)) return true;
    if (subtitle != null && subtitle!.toLowerCase().contains(needle)) {
      return true;
    }
    return keywords.any((k) => k.toLowerCase().contains(needle));
  }
}

/// Pemilih nilai dengan pencarian, pengganti `DropdownButtonFormField`.
///
/// Menu dropdown bawaan jadi tidak terpakai begitu daftarnya panjang — 24
/// bahan baku sudah cukup untuk membuat pengguna menggulir mencari satu nama.
/// Komponen ini membuka bottom sheet berisi kolom pencarian, jadi memilih
/// bahan cukup dengan mengetik dua-tiga huruf.
///
/// Tetap berupa [FormField] supaya `validator` dan `Form.validate()` bekerja
/// persis seperti dropdown yang digantikannya.
class AppSearchableDropdown<T> extends StatelessWidget {
  const AppSearchableDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.label,
    this.hintText,
    this.searchHint = 'Ketik untuk mencari...',
    this.validator,
    this.enabled = true,
    this.isDense = false,
    super.key,
  });

  final T? value;
  final List<AppDropdownOption<T>> options;
  final ValueChanged<T> onChanged;
  final String label;
  final String? hintText;
  final String searchHint;
  final String? Function(T?)? validator;
  final bool enabled;

  /// Rapatkan padding untuk pemakaian di dalam baris yang sempit.
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        // `FormField` menyimpan salinan nilainya sendiri; nilai dari pemanggil
        // tetap yang berlaku supaya perubahan dari luar ikut tampil.
        final selected = _selectedOption();

        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            // Hint diserahkan ke InputDecorator, bukan digambar sendiri di
            // child: kalau keduanya menggambar, label dan hint saling tumpuk
            // ketika belum ada pilihan.
            hintText: hintText,
            errorText: field.errorText,
            enabled: enabled,
            contentPadding: isDense
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 12)
                : null,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          isEmpty: selected == null,
          child: InkWell(
            onTap: enabled ? () => _openPicker(context, field) : null,
            child: selected == null
                ? const SizedBox(height: 20)
                : Text(selected.label, overflow: TextOverflow.ellipsis),
          ),
        );
      },
    );
  }

  AppDropdownOption<T>? _selectedOption() {
    for (final option in options) {
      if (option.value == value) return option;
    }
    return null;
  }

  Future<void> _openPicker(
    BuildContext context,
    FormFieldState<T> field,
  ) async {
    // Tutup keyboard field lain dulu supaya sheet tidak terdorong ke atas.
    FocusScope.of(context).unfocus();

    final picked = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetRadius),
      builder: (_) => _SearchableOptionSheet<T>(
        title: label,
        searchHint: searchHint,
        options: options,
        selected: value,
      ),
    );

    if (picked == null) return;
    field.didChange(picked);
    onChanged(picked);
  }
}

class _SearchableOptionSheet<T> extends StatefulWidget {
  const _SearchableOptionSheet({
    required this.title,
    required this.searchHint,
    required this.options,
    required this.selected,
  });

  final String title;
  final String searchHint;
  final List<AppDropdownOption<T>> options;
  final T? selected;

  @override
  State<_SearchableOptionSheet<T>> createState() =>
      _SearchableOptionSheetState<T>();
}

class _SearchableOptionSheetState<T> extends State<_SearchableOptionSheet<T>> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matches = widget.options
        .where((option) => option.matches(_query))
        .toList();
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.compact),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
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
              child: Text(widget.title, style: theme.textTheme.titleLarge),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          tooltip: 'Hapus pencarian',
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: matches.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          'Tidak ada yang cocok dengan "$_query".',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final option = matches[index];
                        final isSelected = option.value == widget.selected;
                        return ListTile(
                          title: Text(option.label),
                          subtitle: option.subtitle == null
                              ? null
                              : Text(option.subtitle!),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                )
                              : null,
                          selected: isSelected,
                          onTap: () => Navigator.of(context).pop(option.value),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
