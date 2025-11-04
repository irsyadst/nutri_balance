// lib/models/notification_model.dart
import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String subtitle; // Ini akan diisi dari 'body' di backend
  final String iconAsset;
  late bool isRead; // <-- HAPUS 'final' di sini
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.isRead,
    required this.createdAt,
  });

  // Factory constructor untuk parsing JSON dari API
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    // --- PERBAIKIKAN PARSER 'isRead' ---
    // Agar bisa menerima String 'read'/'unread' ATAU boolean true/false
    bool readStatus = false;
    if (json['isRead'] != null) {
      if (json['isRead'] is bool) {
        readStatus = json['isRead'];
      } else if (json['isRead'] is String) {
        readStatus = json['isRead'].toLowerCase() == 'read';
      }
    }
    // --- AKHIR PERBAIKAN ---

    return AppNotification(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      subtitle:
      json['body'] ?? '', // 'body' dari backend menjadi 'subtitle' di app
      iconAsset: json['iconAsset'] ?? 'notification',
      isRead: readStatus, // Gunakan status yang sudah diparsing
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}