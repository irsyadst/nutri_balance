import 'package:flutter/material.dart';

// ListTile kustom untuk item kategori di tab Detail
class DetailCategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DetailCategoryTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // Bungkus dengan InkWell untuk efek ripple
      onTap: onTap,
      borderRadius: BorderRadius.circular(15), // Radius ripple
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding internal
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [ // Shadow halus
            BoxShadow(
              color: Colors.grey.withOpacity(0.06), // Lebih transparan
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
          // Optional: border tipis
          border: Border.all(color: Colors.grey.shade200, width: 0.8),
        ),
        child: Row(
          children: [
            // Ikon Kategori
            Icon(icon, color: Theme.of(context).primaryColor, size: 26),
            const SizedBox(width: 15),
            // Judul Kategori
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            // Ikon Panah Kanan
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400), // Ukuran lebih kecil
          ],
        ),
      ),
    );
  }
}