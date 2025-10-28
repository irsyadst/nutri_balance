import 'package:flutter/material.dart';
import '../../../models/notification_model.dart'; // Buat model ini atau sesuaikan path

// Widget untuk menampilkan satu baris notifikasi
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap; // Callback saat tile di-tap (opsional)
  final VoidCallback? onMoreTap; // Callback saat ikon titik tiga di-tap (opsional)

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onMoreTap,
  });

  // Fungsi helper internal untuk memilih ikon Material berdasarkan string asset
  // (Bisa diperluas atau diganti dengan logika pemetaan yang lebih baik)
  IconData _getIconData(String asset) {
    switch (asset) {
      case 'food_plate':
        return Icons.restaurant_menu_outlined; // Gunakan ikon outlined
      case 'exercise':
        return Icons.fitness_center_outlined; // Gunakan ikon outlined
      case 'food_box':
        return Icons.cake_outlined; // Gunakan ikon outlined
      case 'trophy':
        return Icons.emoji_events_outlined; // Gunakan ikon outlined
      default:
        return Icons.notifications_outlined; // Ikon notifikasi default
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Avatar (Lingkaran Ikon)
      leading: CircleAvatar(
        radius: 28, // Ukuran avatar
        backgroundColor: notification.iconBgColor, // Warna background dari model
        child: Icon(
          _getIconData(notification.iconAsset), // Dapatkan ikon
          color: notification.iconColor, // Warna ikon dari model
          size: 28, // Ukuran ikon di dalam avatar
        ),
      ),

      // Judul Notifikasi
      title: Text(
        notification.title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 15),
        maxLines: 1, // Batasi judul 1 baris
        overflow: TextOverflow.ellipsis, // Tambahkan ellipsis jika terlalu panjang
      ),

      // Subtitle (Waktu/Detail Tambahan)
      subtitle: Text(
        notification.subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),

      // Aksi (Ikon Titik Tiga Vertikal)
      trailing: IconButton( // Gunakan IconButton agar area tap lebih jelas
        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
        onPressed: onMoreTap, // Gunakan callback onMoreTap
        tooltip: 'Opsi lainnya', // Tooltip untuk aksesibilitas
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Sesuaikan padding
      onTap: onTap, // Gunakan callback onTap
      dense: false, // Atur dense ke false untuk padding vertikal default
    );
  }
}