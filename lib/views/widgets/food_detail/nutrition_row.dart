import 'package:flutter/material.dart';

class NutritionRow extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final bool isHeader;

  const NutritionRow({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!isHeader)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              if (!isHeader) const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isHeader ? 20 : 16,
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                  color: isHeader ? color : Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHeader ? 20 : 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
              color: isHeader ? color : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
