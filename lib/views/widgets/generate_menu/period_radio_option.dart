import 'package:flutter/material.dart';

class PeriodRadioOption extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;


  final ValueChanged<String?>? onChanged;
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
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: activeColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}