import 'package:flutter/material.dart';

// Widget untuk menampilkan bagian Kemajuan Kegiatan (termasuk Bar Chart)
class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});

  // Data dummy (bisa dipindahkan ke state management jika perlu)
  final List<double> dailyProgress = const [0.3, 0.6, 0.7, 0.5, 0.9, 0.2, 0.8]; // Nilai progress 0.0 - 1.0
  final List<String> days = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kemajuan Kegiatan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              // TODO: Ganti dengan DropdownButton jika perlu interaksi
              child: const Row(
                children: [
                  Text('Weekly', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.w600)),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF007BFF)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Bar Chart
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(dailyProgress.length, (index) {
            return ProgressBar(day: days[index], progress: dailyProgress[index]);
          }),
        ),
      ],
    );
  }
}

// Widget untuk satu batang progress bar
class ProgressBar extends StatelessWidget {
  final String day;
  final double progress;
  final double barWidth;
  final double barMaxHeight;

  const ProgressBar({
    super.key,
    required this.day,
    required this.progress,
    this.barWidth = 25,
    this.barMaxHeight = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bar Stack
        SizedBox(
          height: barMaxHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background Bar (Light Gray)
              Container(
                width: barWidth,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Progress Bar (Blue)
              Container(
                width: barWidth,
                height: barMaxHeight * progress, // Tinggi berdasarkan progress
                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Day Label
        Text(day, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
