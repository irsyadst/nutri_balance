import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade100,
              child: Icon(icon, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}