import 'package:flutter/material.dart';

class PeriodRadioOption extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue; // Nilai grup saat ini
  final ValueChanged<String?> onChanged; // Callback saat pilihan berubah
  final Color activeColor;

  const PeriodRadioOption({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Latar belakang abu-abu muda
        borderRadius: BorderRadius.circular(15),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged, // Gunakan callback dari parameter
        activeColor: activeColor, // Gunakan warna aktif dari parameter
        controlAffinity: ListTileControlAffinity.trailing, // Radio di kanan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // VisualDensity bisa ditambahkan jika ingin lebih rapat
        // visualDensity: VisualDensity.compact,
      ),
    );
  }
}