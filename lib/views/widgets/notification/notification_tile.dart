import 'package:flutter/material.dart';
// --- IMPOR YANG HILANG ---
import '../../../models/notification_model.dart';
import 'package:intl/intl.dart'; // Untuk format waktu
// --- AKHIR IMPOR ---

// Widget untuk menampilkan satu baris notifikasi
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMoreTap,
  });

  // Fungsi helper internal untuk memilih ikon Material
  IconData _getIconData(String asset) {
    switch (asset) {
      case 'food_plate':
        return Icons.restaurant_menu_outlined;
      case 'exercise':
        return Icons.fitness_center_outlined;
      case 'food_box':
        return Icons.cake_outlined;
      case 'trophy':
        return Icons.emoji_events_outlined;
      case 'water_drop':
        return Icons.water_drop_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  // --- TAMBAHAN: Helper untuk warna ikon ---
  Color _getIconColor(String asset) {
    switch (asset) {
      case 'food_plate':
      case 'food_box':
        return const Color(0xFFE8963D); // Oranye
      case 'exercise':
      case 'trophy':
        return const Color(0xFF6A82FF); // Biru
      case 'water_drop':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  // --- TAMBAHAN: Helper untuk warna background ikon ---
  Color _getIconBgColor(String asset) {
    switch (asset) {
      case 'food_plate':
      case 'food_box':
        return const Color(0xFFFBEBCD); // Krem Muda
      case 'exercise':
      case 'trophy':
        return const Color(0xFFEBF0FF); // Biru Muda
      case 'water_drop':
        return const Color(0xFFE0F7FA);
      default:
        return Colors.grey.shade100;
    }
  }

  // --- TAMBAHAN: Helper untuk format waktu ---
  String _formatTimestamp(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else {
      // Tampilkan tanggal (misal: 30 Okt)
      return DateFormat('d MMM', 'id_ID').format(createdAt);
    }
  }


  @override
  Widget build(BuildContext context) {
    // --- Panggil helper baru ---
    final iconData = _getIconData(notification.iconAsset);
    final iconColor = _getIconColor(notification.iconAsset);
    final iconBgColor = _getIconBgColor(notification.iconAsset);
    // Error 'createdAt' terjadi di sini
    final timestamp = _formatTimestamp(notification.createdAt);

    return ListTile(
      // Avatar (Lingkaran Ikon)
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: iconBgColor, // Warna background dari helper
        child: Icon(
          iconData, // Ikon dari helper
          color: iconColor, // Warna ikon dari helper
          size: 28,
        ),
      ),

      // Judul Notifikasi
      title: Text(
        notification.title,
        style: TextStyle(
          // Error 'isRead' terjadi di sini
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
            color: Colors.black87,
            fontSize: 15
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      // Subtitle (Waktu/Detail Tambahan)
      subtitle: Text(
        // Ganti subtitle dari model dengan timestamp
        timestamp,
        style: TextStyle(
          // Error 'isRead' terjadi di sini
          color: notification.isRead ? Colors.grey[500] : Theme.of(context).primaryColor,
          fontSize: 13,
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
        ),
      ),

      // Aksi (Ikon Titik Tiga Vertikal)
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
        onPressed: onMoreTap,
        tooltip: 'Opsi lainnya',
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: onTap,
      dense: false,
      // Error 'isRead' terjadi di sini
      tileColor: notification.isRead ? Colors.white : const Color(0xFFF6F8FF),
    );
  }
}

