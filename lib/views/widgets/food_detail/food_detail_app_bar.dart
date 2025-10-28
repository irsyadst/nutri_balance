import 'package:flutter/material.dart';

import '../../../models/meal_models.dart';

// SliverAppBar khusus untuk halaman detail makanan
class FoodDetailAppBar extends StatelessWidget {
  final MealItem mealItem; // Mungkin perlu data mealItem untuk gambar, dll.

  const FoodDetailAppBar({
    super.key,
    required this.mealItem,
  });

  @override
  Widget build(BuildContext context) {
    // Di sini Anda bisa menambahkan logika untuk menampilkan gambar
    // Misalnya menggunakan mealItem.imageAsset jika ada
    final String imagePlaceholder = mealItem.iconAsset; // Ganti jika ada field gambar utama

    return SliverAppBar(
      expandedHeight: 300.0, // Tinggi area gambar saat diperluas
      floating: false, // Tidak mengambang saat scroll ke bawah
      pinned: true,    // Tetap terlihat saat scroll ke atas
      stretch: true,   // Efek stretch saat overscroll
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0), // Padding agar tidak terlalu mepet
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 10.0), // Padding agar tidak terlalu mepet
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black),
              onPressed: () {
                // TODO: Implementasi aksi more options
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.zero, // Hapus padding default title
        // Background berisi gambar makanan
        background: imagePlaceholder.isNotEmpty
            ? Image.asset(
          imagePlaceholder, // Ganti dengan gambar asli jika ada
          fit: BoxFit.cover,
          // Error builder jika gambar gagal dimuat
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade200,
            child: const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 100)),
          ),
        )
            : Container( // Placeholder jika tidak ada gambar
          color: Colors.grey.shade200,
          child: const Center(child: Icon(Icons.fastfood, size: 150, color: Colors.grey)),
        ),
        stretchModes: const [StretchMode.zoomBackground], // Efek zoom saat stretch
      ),
    );
  }
}
