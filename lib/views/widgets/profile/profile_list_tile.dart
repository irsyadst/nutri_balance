import 'package:flutter/material.dart';
class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showArrow;

  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600], size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      trailing: showArrow
          ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}
class ProfileListDivider extends StatelessWidget {
  const ProfileListDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        height: 1,
        thickness: 0.8,
        color: Colors.grey[100],
      ),
    );
  }
}