import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String subtitle; // Ini akan diisi dari 'body' di backend
  final String iconAsset;
  final bool isRead;
  final DateTime createdAt;

  // Hapus: iconColor dan iconBgColor (ini akan ditangani di UI)

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.isRead,
    required this.createdAt,
  });

  // Factory constructor untuk parsing JSON dari API
  // Pastikan file ini di-impor di api_service.dart dan notification_tile.dart
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      subtitle: json['body'] ?? '', // 'body' dari backend menjadi 'subtitle' di app
      iconAsset: json['iconAsset'] ?? 'notification',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

