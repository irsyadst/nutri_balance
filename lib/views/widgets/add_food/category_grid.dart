import 'package:flutter/material.dart';
import 'category_card.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
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
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 2.5,
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
            print('Kategori diklik: ${category['name']}');
          },
        );
      },
    );
  }
}