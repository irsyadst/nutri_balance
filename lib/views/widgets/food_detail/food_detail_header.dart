import 'package:flutter/material.dart';

class FoodDetailHeader extends StatelessWidget {
  final String foodName;
  final String authorName; // Contoh: Nama pembuat resep
  final bool isFavorite; // Status favorit
  final VoidCallback onFavoriteTap; // Aksi saat ikon favorit ditekan

  const FoodDetailHeader({
    super.key,
    required this.foodName,
    this.authorName = "NutriBalance Chef", // Default author
    this.isFavorite = false, // Default tidak favorit
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start, // Align text ke atas
      children: [
        // Nama Makanan dan Author
        Expanded( // Agar teks bisa wrap jika panjang
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foodName,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'by $authorName',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10), // Jarak antara teks dan ikon
        // Ikon Hati (Favorit)
        InkWell( // Gunakan InkWell untuk efek ripple
          onTap: onFavoriteTap,
          borderRadius: BorderRadius.circular(50), // Bentuk bulat
          child: Container(
            padding: const EdgeInsets.all(8), // Padding dalam ikon
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border, // Ganti ikon berdasarkan status
              color: const Color(0xFFEF5350), // Warna merah
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}