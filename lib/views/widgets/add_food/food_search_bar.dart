import 'package:flutter/material.dart';

class FoodSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const FoodSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Cari makanan', // Sesuaikan placeholder jika perlu
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        // Tambahkan suffixIcon jika diperlukan (misal untuk filter)
        // suffixIcon: const Icon(Icons.filter_list, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFF3F4F6), // Warna abu muda
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onChanged: onChanged,
    );
  }
}