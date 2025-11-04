// lib/views/widgets/notification/notification_tile.dart

import 'package:flutter/material.dart';
import '../../../models/notification_model.dart';
import 'package:intl/intl.dart';

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

  // (Fungsi helper _getIconData, _getIconColor, _getIconBgColor, _formatTimestamp...)
  // ... (Salin 4 fungsi helper dari file Anda) ...
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

  String _formatTimestamp(DateTime createdAt) {
    Intl.defaultLocale = 'id_ID';
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
      return DateFormat('d MMM', 'id_ID').format(createdAt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconData(notification.iconAsset);
    final iconColor = _getIconColor(notification.iconAsset);
    final iconBgColor = _getIconBgColor(notification.iconAsset);
    final timestamp = _formatTimestamp(notification.createdAt);

    // --- PERBAIKAN: Gunakan boolean 'isRead' ---
    final bool isNotificationRead = notification.isRead;

    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: iconBgColor,
        child: Icon(iconData, color: iconColor, size: 28),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          // --- PERBAIKAN DI SINI ---
            fontWeight:
            isNotificationRead ? FontWeight.w500 : FontWeight.bold,
            color: Colors.black87,
            fontSize: 15),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        // Gunakan subtitle dari model (yang di-map dari 'body')
        notification.subtitle.isNotEmpty ? notification.subtitle : timestamp,
        style: TextStyle(
          // --- PERBAIKAN DI SINI ---
          color: isNotificationRead
              ? Colors.grey[500]
              : Theme.of(context).primaryColor,
          fontSize: 13,
          fontWeight: isNotificationRead ? FontWeight.normal : FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
        onPressed: onMoreTap,
        tooltip: 'Opsi lainnya',
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: onTap,
      dense: false,
      // --- PERBAIKAN DI SINI ---
      tileColor:
      isNotificationRead ? Colors.white : const Color(0xFFF6F8FF),
    );
  }
}