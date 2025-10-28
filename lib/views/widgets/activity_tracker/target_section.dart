import 'package:flutter/material.dart';

// Widget untuk menampilkan bagian Target Hari Ini
class TargetSection extends StatelessWidget {
  const TargetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3FF), // Latar belakang biru muda
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Hari Ini',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF007BFF), size: 28),
                  onPressed: () {
                    // TODO: Tambahkan aksi ketika tombol add ditekan
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(child: TargetCard(value: '8L', label: 'Asupan Air', icon: Icons.local_drink, backgroundColor: Color(0xFF90CAF9))),
              SizedBox(width: 15),
              Expanded(child: TargetCard(value: '2400', label: 'Langkah Kaki', icon: Icons.directions_walk, backgroundColor: Color(0xFFFFF176))),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget untuk kartu individual di dalam Target Section
class TargetCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon; // Menggunakan IconData Flutter
  final Color backgroundColor;

  const TargetCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row( // Row untuk menyejajarkan icon dan teks
        children: [
          // Icon di sebelah kiri
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.2), // Background lebih soft
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: backgroundColor, size: 24), // Tampilkan icon
          ),
          const SizedBox(width: 12),
          // Teks Value dan Label di sebelah kanan icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87), // Ukuran value lebih besar
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}