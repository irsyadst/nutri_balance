import 'package:flutter/material.dart';

class RecentFoodChip extends StatelessWidget {
  final String foodName;
  final VoidCallback? onTap; // Opsional: Tambahkan aksi jika chip diklik

  const RecentFoodChip({
    super.key,
    required this.foodName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip( // Gunakan ActionChip jika ingin ada onTap
      label: Text(foodName, style: TextStyle(color: Colors.grey.shade700)),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onPressed: onTap, // Panggil onTap jika ada
    );
  }
}