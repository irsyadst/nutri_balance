import 'package:flutter/material.dart';
import '../../../models/meal_models.dart'; // Import model DailySchedule

// Widget untuk menampilkan daftar jadwal makan harian
class DailyScheduleList extends StatelessWidget {
  final Map<String, List<DailySchedule>> schedule;
  final Function(String mealType)? onItemTap; // Callback saat item di-tap

  const DailyScheduleList({
    super.key,
    required this.schedule,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // Ubah map schedule menjadi list widget
    final List<Widget> mealWidgets = schedule.entries.map((entry) {
      final mealType = entry.key;
      // Hitung total kalori untuk tipe makanan ini
      final totalCalories = entry.value.fold<int>(0, (sum, item) => sum + item.calories);
      return _ScheduleItem( // Gunakan widget internal _ScheduleItem
        mealType: mealType,
        calories: totalCalories,
        onTap: () {
          if (onItemTap != null) {
            onItemTap!(mealType); // Panggil callback jika ada
          }
          // TODO: Aksi default jika tidak ada callback
          print('Schedule item tapped: $mealType');
        },
      );
    }).toList();

    // Tampilkan pesan jika tidak ada jadwal
    if (mealWidgets.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0), // Beri padding atas/bawah
        child: Center(
          child: Text(
            "Tidak ada jadwal makan untuk tanggal ini.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    // Tampilkan ListView jika ada jadwal
    return ListView.separated(
      shrinkWrap: true, // Wajib di dalam SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Nonaktifkan scroll internal
      itemCount: mealWidgets.length,
      itemBuilder: (context, index) => mealWidgets[index],
      // Pemisah antar item
      separatorBuilder: (context, index) => const SizedBox(height: 15),
    );
  }
}


// Widget internal untuk satu item jadwal
class _ScheduleItem extends StatelessWidget {
  final String mealType;
  final int calories;
  final VoidCallback onTap;

  const _ScheduleItem({
    required this.mealType,
    required this.calories,
    required this.onTap,
  });

  // Helper untuk mendapatkan ikon berdasarkan mealType
  IconData _getIconForMealType(String type) {
    switch (type.toLowerCase()) {
      case 'sarapan':
        return Icons.wb_sunny_outlined;
      case 'makan siang':
        return Icons.restaurant_menu_outlined;
      case 'makan malam':
        return Icons.nights_stay_outlined;
      case 'snack': // Tambahkan case untuk snack jika ada
      case 'makanan ringan':
        return Icons.fastfood_outlined;
      default:
        return Icons.circle_outlined; // Ikon default
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell( // Bungkus dengan InkWell agar bisa di-tap
      onTap: onTap,
      borderRadius: BorderRadius.circular(15), // Efek ripple
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08), // Shadow halus
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 0.5), // Optional: border tipis
        ),
        child: Row(
          children: [
            // Avatar Ikon
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey.shade100, // Background ikon
              child: Icon(
                _getIconForMealType(mealType),
                color: Colors.grey.shade600,
                size: 28,
              ),
            ),
            const SizedBox(width: 15),
            // Nama Meal dan Kalori
            Expanded( // Expanded agar teks tidak overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$calories cal',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Optional: Tambahkan ikon panah jika perlu
            // const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}