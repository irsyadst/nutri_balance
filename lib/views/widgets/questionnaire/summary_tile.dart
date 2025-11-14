import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final bool hasDivider;

  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          if (hasDivider) Divider(height: 1, thickness: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }
}