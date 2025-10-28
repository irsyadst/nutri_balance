import 'package:flutter/material.dart';

class CategorySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterPressed; // Callback for filter icon

  const CategorySearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search Pancake', // Placeholder specific to this screen
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          // Filter Icon as suffix
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune, color: Colors.grey),
            onPressed: onFilterPressed, // Use the callback
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFF3F4F6), // Light gray background
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}