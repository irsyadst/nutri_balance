import 'package:flutter/material.dart';

class GenderRadioOption extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final Color activeColor;

  const GenderRadioOption({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: activeColor,
      contentPadding: EdgeInsets.zero, // Hapus padding default
      controlAffinity: ListTileControlAffinity.leading, // Radio di kiri
      visualDensity: VisualDensity.compact, // Buat lebih rapat
    );
  }
}