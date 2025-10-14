import 'package:flutter/material.dart';

class TargetCard extends StatelessWidget {
  final IconData icon; final String title; final String value; final Color color;
  const TargetCard({super.key, required this.icon, required this.title, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 15),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ]),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ]),
    );
  }
}
