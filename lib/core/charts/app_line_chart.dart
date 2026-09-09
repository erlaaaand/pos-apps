import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_radius.dart';

/// Satu deret garis: nama, warna, dan titik-titiknya terhadap sumbu X.
class LineSeries {
  const LineSeries({
    required this.name,
    required this.color,
    required this.spots,
  });

  final String name;
  final Color color;

  /// Kunci X memakai indeks kategori sumbu (lihat [AppLineChart.xLabels]),
  /// bukan milidetik — supaya jarak antar minggu selalu sama lebarnya walau
  /// ada minggu yang kosong.
  final List<FlSpot> spots;
}

/// Grafik garis untuk perubahan sepanjang waktu.
///
/// Sengaja hanya menyediakan satu sumbu Y. Menumpuk dua satuan berbeda
/// (misal porsi dan rupiah) pada satu grafik membuat perpotongan garisnya
/// tampak bermakna padahal tidak — kalau butuh keduanya, pakai dua grafik.
class AppLineChart extends StatelessWidget {
  const AppLineChart({
    required this.series,
    required this.xLabels,
    required this.formatY,
    this.formatTooltipY,
    super.key,
  });

  final List<LineSeries> series;

  /// Label sumbu X berurutan; indeksnya dipakai sebagai nilai X.
  final List<String> xLabels;

  /// Pemformat angka sumbu Y (ringkas — sumbu bukan tempat angka panjang).
  final String Function(double value) formatY;

  /// Pemformat nilai di tooltip. Default mengikuti [formatY].
  final String Function(double value)? formatTooltipY;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gridColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final maxY = _maxY();
    final tooltipFormatter = formatTooltipY ?? formatY;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        minX: 0,
        maxX: (xLabels.length - 1).toDouble().clamp(0, double.infinity),
        // Garis bantu horizontal saja: garis vertikal menambah kepadatan
        // tanpa membantu membaca besaran.
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: gridColor, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: maxY / 4,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  formatY(value),
                  style: labelStyle,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, _) {
                final index = value.round();
                if (index < 0 || index >= xLabels.length) {
                  return const SizedBox.shrink();
                }
                // Pada rentang panjang, sebagian label dilewati agar tidak
                // bertumpuk — titiknya tetap utuh, hanya labelnya dijarangkan.
                final step = (xLabels.length / 6).ceil();
                if (step > 1 && index % step != 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(xLabels[index], style: labelStyle),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => theme.colorScheme.inverseSurface,
            tooltipBorderRadius: BorderRadius.circular(AppRadius.sm),
            getTooltipItems: (touchedSpots) => [
              for (final spot in touchedSpots)
                LineTooltipItem(
                  '${series[spot.barIndex].name}\n'
                  '${tooltipFormatter(spot.y)}',
                  TextStyle(
                    color: theme.colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        lineBarsData: [
          for (final item in series)
            LineChartBarData(
              spots: item.spots,
              color: item.color,
              barWidth: 2,
              isCurved: false,
              dotData: FlDotData(
                show: true,
                getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                  radius: 4,
                  color: item.color,
                  // Cincin setebal 2px berwarna latar memisahkan titik yang
                  // saling menimpa antar deret.
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Batas atas sumbu Y dengan sedikit ruang kepala, dan tidak pernah nol
  /// (nol membuat pembagian interval garis bantu menjadi tak hingga).
  double _maxY() {
    var max = 0.0;
    for (final item in series) {
      for (final spot in item.spots) {
        if (spot.y > max) max = spot.y;
      }
    }
    if (max <= 0) return 1;
    return max * 1.2;
  }
}
