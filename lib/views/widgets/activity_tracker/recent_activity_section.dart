import 'package:flutter/material.dart';

// Widget untuk menampilkan bagian Aktivitas Terbaru
class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  // Data dummy (bisa dipindahkan)
  final List<Map<String, dynamic>> recentActivities = const [
    {
      'title': 'Minum 300ml Air',
      'subtitle': 'Sekitar 3 menit yang lalu',
      'avatarBgColor': Color(0xFFE7F3FF),
      'avatarFgColor': Color(0xFF007BFF),
      'icon': Icons.water_drop,
    },
    {
      'title': 'Makan Camilan (Fitbar)',
      'subtitle': 'Sekitar 10 menit yang lalu',
      'avatarBgColor': Color(0xFFF9E7E7),
      'avatarFgColor': Color(0xFFC70039),
      'icon': Icons.fastfood,
    },
    // Tambahkan aktivitas lain jika perlu
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            TextButton(
              onPressed: () {
                // TODO: Aksi untuk melihat semua aktivitas
              },
              child: const Text('See more', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Daftar Aktivitas
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Non-scrollable list inside SingleChildScrollView
          itemCount: recentActivities.length,
          itemBuilder: (context, index) {
            final activity = recentActivities[index];
            return ActivityTile(
              title: activity['title'],
              subtitle: activity['subtitle'],
              avatarBgColor: activity['avatarBgColor'],
              avatarFgColor: activity['avatarFgColor'],
              icon: activity['icon'],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 15),
        ),
      ],
    );
  }
}

// Widget untuk satu item/tile aktivitas
class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color avatarBgColor;
  final Color avatarFgColor;
  final IconData icon;

  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.avatarBgColor,
    required this.avatarFgColor,
    required this.icon,
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
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: avatarBgColor,
            child: Icon(
              icon,
              color: avatarFgColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          // Title & Subtitle
          Expanded( // Expanded agar teks tidak overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  overflow: TextOverflow.ellipsis, // Atasi jika judul terlalu panjang
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}