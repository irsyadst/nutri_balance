import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(thickness: 1, endIndent: 15, color: Color(0xFFDDDDDD))), // Lighter divider
        Text('OR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        Expanded(child: Divider(thickness: 1, indent: 15, color: Color(0xFFDDDDDD))),
      ],
    );
  }
}