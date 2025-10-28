import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'dart:math'; // Untuk min/max

// Widget untuk menampilkan kartu progres berat badan di tab ringkasan
class WeightProgressCard extends StatelessWidget {
  final double currentWeight;
  final double weightChangePercent;
  final String weightPeriod;
  final List<FlSpot> weightSpots; // Data untuk line chart

  const WeightProgressCard({
    super.key,
    required this.currentWeight,
    required this.weightChangePercent,
    required this.weightPeriod,
    required this.weightSpots,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    // Tentukan warna teks persen berdasarkan positif/negatif
    final percentColor = weightChangePercent >= 0 ? Colors.red.shade400 : Colors.green.shade500;
    // Tentukan teks persen dengan tanda +/-
    final percentText = '${weightChangePercent >= 0 ? '+' : ''}${weightChangePercent.toStringAsFixed(1)}%'; // 1 angka desimal

    // Cari nilai Y min/max dari data spot untuk skala grafik (tambah sedikit padding)
    final double minY = weightSpots.map((spot) => spot.y).reduce(min) - 2;
    final double maxY = weightSpots.map((spot) => spot.y).reduce(max) + 2;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Informasi Berat Badan Saat Ini
        const Text('Berat Badan', style: TextStyle(fontSize: 15, color: Colors.grey)), // Label
        const SizedBox(height: 2),
        Text(
          '${currentWeight.toStringAsFixed(1)} kg', // Tampilkan berat (1 desimal) + unit
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold), // Ukuran font
        ),
        const SizedBox(height: 4),
        // Informasi Perubahan Berat
        Text(
          '$weightPeriod $percentText', // Tampilkan periode dan persen perubahan
          style: TextStyle(
            fontSize: 14,
            color: percentColor, // Warna hijau/merah
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),

        // Line Chart
        SizedBox(
          height: 150, // Tinggi grafik
          child: LineChart(
            LineChartData(
              minY: minY, // Skala Y dinamis
              maxY: maxY,
              gridData: const FlGridData(show: false), // Sembunyikan grid
              titlesData: FlTitlesData( // Sembunyikan semua label axis
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles( // Tampilkan label bulan di bawah
                  sideTitles: SideTitles(
                    showTitles: true, reservedSize: 25, interval: 2, // Sesuaikan interval jika perlu
                    getTitlesWidget: (value, meta) {
                      // Contoh label bulan (sesuaikan jika data X berbeda)
                      const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
                      final index = value.toInt();
                      if (index >= 0 && index < labels.length && index % 2 == 0) { // Tampilkan label per 2 interval
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 4.0),
                          child: Text(labels[index], style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                        );
                      }
                      return const SizedBox.shrink(); // Kosongkan untuk label lain
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false), // Sembunyikan border
              lineBarsData: [
                LineChartBarData(
                  spots: weightSpots, // Gunakan data spot
                  isCurved: true, // Kurva halus
                  color: primaryColor, // Warna garis primer
                  barWidth: 3, // Lebar garis
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false), // Sembunyikan titik
                  // Area di bawah garis (gradient transparan)
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [ primaryColor.withOpacity(0.3), primaryColor.withOpacity(0.0) ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              // Nonaktifkan tooltip saat disentuh (opsional)
              lineTouchData: const LineTouchData(enabled: false),
            ),

          ),
        ),
      ],
    );
  }
}