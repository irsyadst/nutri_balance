import 'package:flutter/material.dart';

// Header Widget for Modal Bottom Sheet Pickers
class PickerHeader extends StatelessWidget {
  final String title;
  final VoidCallback onDone;
  final VoidCallback? onCancel;

  const PickerHeader({
    super.key,
    required this.title,
    required this.onDone,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            // Use provided onCancel or default pop behavior
            onPressed: onCancel ?? () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextButton(
            onPressed: onDone,
            child: const Text('Pilih', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}