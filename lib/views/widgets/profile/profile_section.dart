import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 12.0), // Padding judul
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), // Font size lebih kecil
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 3)
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }
}