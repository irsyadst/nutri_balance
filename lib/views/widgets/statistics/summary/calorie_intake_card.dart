import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format angka
import 'dart:math'; // Untuk min/max

// Widget untuk menampilkan kartu asupan kalori di tab ringkasan
class CalorieIntakeCard extends StatelessWidget {
  final int caloriesToday;
  final double calorieChangePercent;
  final Map<String, double> calorieDataPerMeal; // Data kalori per jenis makanan
  final double maxCaloriePerMeal; // Nilai maksimum untuk skala bar

  const CalorieIntakeCard({
    super.key,
    required this.caloriesToday,
    required this.calorieChangePercent,
    required this.calorieDataPerMeal,
    required this.maxCaloriePerMeal,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna dan teks persen
    final percentColor = calorieChangePercent >= 0 ? Colors.green.shade500 : Colors.red.shade400;
    final percentText = '${calorieChangePercent >= 0 ? '+' : ''}${calorieChangePercent.toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info Kalori Hari Ini
        const Text('Kalori', style: TextStyle(fontSize: 15, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          // Format angka dengan pemisah ribuan (Indonesia)
          NumberFormat.decimalPattern('id_ID').format(caloriesToday),
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Hari ini $percentText', // Tampilkan persen perubahan
          style: TextStyle( fontSize: 14, color: percentColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),

        // Bar Chart Per Meal
        SizedBox(
          height: 125, // Tinggi bar chart container
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Beri jarak antar bar
            crossAxisAlignment: CrossAxisAlignment.end, // Align bar ke bawah
            // Buat bar untuk setiap item di calorieDataPerMeal
            children: calorieDataPerMeal.entries.map((entry) {
              return Expanded( // Gunakan Expanded agar lebar bar fleksibel
                child: _CalorieBar( // Gunakan widget internal _CalorieBar
                  label: entry.key,
                  value: entry.value,
                  maxValue: maxCaloriePerMeal,
                  color: Theme.of(context).primaryColor, // Warna bar
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}


// Widget internal untuk satu batang kalori
class _CalorieBar extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final Color color;

  const _CalorieBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung progres (0.0 - 1.0), pastikan maxValue > 0
    final double progress = maxValue > 0 ? max(0.0, min(1.0, value / maxValue)) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), // Jarak horizontal antar bar
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Mulai dari bawah
        children: [
          // Bar Stack (Background & Progress)
          Container(
            width: 50, // Lebar bar (bisa disesuaikan)
            height: 80, // Tinggi maksimum bar
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Warna background bar
              borderRadius: const BorderRadius.all(Radius.circular(8)), // Rounded corner
            ),
            // Gunakan alignment untuk menempatkan progress bar di bawah
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80 * progress, // Tinggi progress bar sesuai nilai
              decoration: BoxDecoration(
                color: color, // Warna progress bar
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 8), // Jarak bar ke label
          // Label Meal (Sarapan, dll.)
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}