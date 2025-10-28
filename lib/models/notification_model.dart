import 'package:flutter/material.dart';

class AppNotification {
  final String title;
  final String subtitle;
  final String iconAsset; // Nama aset atau identifier ikon
  final Color iconColor;   // Warna ikon
  final Color iconBgColor; // Warna background avatar ikon

  const AppNotification({
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.iconColor,
    required this.iconBgColor,
  });
}