import 'package:flutter/material.dart';

// Model Notifikasi sederhana
class AppNotification {
  final String title;
  final String subtitle;
  final String iconAsset; // Placeholder untuk model icon
  final Color iconColor;
  final Color iconBgColor;

  const AppNotification({
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Data Notifikasi Statis meniru yang ada di gambar
  final List<AppNotification> notifications = const [
    AppNotification(
      title: 'Hei, sudah waktunya makan siang',
      subtitle: 'Sekitar 1 menit yang lalu',
      iconAsset: 'food_plate',
      iconColor: Color(0xFFE8963D), // Oranye
      iconBgColor: Color(0xFFFBEBCD), // Krem Muda
    ),
    AppNotification(
      title: 'Jangan lewatkan latihan tubuh Anda',
      subtitle: 'Sekitar 3 jam yang lalu',
      iconAsset: 'exercise',
      iconColor: Color(0xFF6A82FF), // Biru
      iconBgColor: Color(0xFFEBF0FF), // Biru Muda
    ),
    AppNotification(
      title: 'Hei, mari tambahkan makanan untuk s...',
      subtitle: 'Sekitar 3 jam yang lalu',
      iconAsset: 'food_box',
      iconColor: Color(0xFFE8963D),
      iconBgColor: Color(0xFFFBEBCD),
    ),
    AppNotification(
      title: 'Selamat, Anda telah menyelesaikan Ola...',
      subtitle: '29 Mei',
      iconAsset: 'trophy',
      iconColor: Color(0xFF6A82FF),
      iconBgColor: Color(0xFFEBF0FF),
    ),
    AppNotification(
      title: 'Hei, sudah waktunya makan siang',
      subtitle: '8 April',
      iconAsset: 'food_plate',
      iconColor: Color(0xFFE8963D),
      iconBgColor: Color(0xFFFBEBCD),
    ),
    AppNotification(
      title: 'Ups, Anda kehilangan Lowerbo...',
      subtitle: '3 April',
      iconAsset: 'exercise',
      iconColor: Color(0xFF6A82FF),
      iconBgColor: Color(0xFFEBF0FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.more_horiz, color: Colors.black87), // Icon titik tiga
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationTile(notification: notification);
        },
      ),
    );
  }
}

// Widget untuk setiap baris notifikasi
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  const NotificationTile({super.key, required this.notification});

  // Fungsi sederhana untuk memilih ikon Material yang mirip dengan asset di gambar
  IconData _getIconData(String asset) {
    switch (asset) {
      case 'food_plate':
        return Icons.restaurant_menu;
      case 'exercise':
        return Icons.fitness_center;
      case 'food_box':
        return Icons.cake;
      case 'trophy':
        return Icons.emoji_events;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Avatar (Lingkaran Ikon)
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: notification.iconBgColor,
        child: Icon(
          _getIconData(notification.iconAsset),
          color: notification.iconColor,
          size: 28,
        ),
      ),
      
      // Judul
      title: Text(
        notification.title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 15),
      ),
      
      // Subtitle (Waktu)
      subtitle: Text(
        notification.subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
      
      // Aksi (Titik Tiga Vertikal)
      trailing: const Icon(
        Icons.more_vert,
        color: Colors.grey,
        size: 20,
      ),
      
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: () {
        // Aksi ketika notifikasi diklik
      },
    );
  }
}