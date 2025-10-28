import 'package:flutter/material.dart';
import 'category_card.dart'; // Import CategoryCard

class CategoryGrid extends StatelessWidget {
  // Terima data kategori dari luar
  final List<Map<String, dynamic>> categories;
  // Callback saat kategori diklik (opsional)
  final Function(String)? onCategoryTap;

  const CategoryGrid({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 2.5, // Sesuaikan rasio jika perlu
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          name: category['name'],
          icon: category['icon'],
          onTap: () {
            // Panggil callback jika ada
            if (onCategoryTap != null) {
              onCategoryTap!(category['name']);
            }
            // TODO: Logika default jika tidak ada callback (misal navigasi)
            print('Kategori diklik: ${category['name']}');
          },
        );
      },
    );
  }
}