import 'package:flutter/material.dart';

// Reusable Widget for Fields that Trigger a Picker (like TextField/Dropdown appearance)
class PickerTriggerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData trailingIcon;

  const PickerTriggerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailingIcon = Icons.edit_outlined, // Default edit icon
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( // Allow text to expand and potentially wrap/ellipsis
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis, // Handle long text
              ),
            ),
            Icon(trailingIcon, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}