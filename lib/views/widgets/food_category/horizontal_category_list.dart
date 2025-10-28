import 'package:flutter/material.dart';

class HorizontalCategoryList extends StatelessWidget {
  // Define a simple structure for category data
  final List<Map<String, dynamic>> categories = const [
    {'name': 'Salad', 'bgColor': Color(0xFFE8F5E9), 'icon': Icons.lunch_dining},
    {'name': 'Kue', 'bgColor': Color(0xFFF3E5F5), 'icon': Icons.cake},
    {'name': 'Pie', 'bgColor': Color(0xFFE0F7FA), 'icon': Icons.pie_chart},
    {'name': 'Smoothies', 'bgColor': Color(0xFFFFF3E0), 'icon': Icons.blender},
    // Add more categories if needed
  ];
  final Function(String)? onCategoryTap; // Callback when a category is tapped

  const HorizontalCategoryList({
    super.key,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Fixed height for the list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _buildCategoryItem(
            name: cat['name'] as String,
            bgColor: cat['bgColor'] as Color,
            icon: cat['icon'] as IconData,
            onTap: () {
              if (onCategoryTap != null) {
                onCategoryTap!(cat['name'] as String);
              }
              print('Category tapped: ${cat['name']}'); // Default action
            },
          );
        },
      ),
    );
  }

  // Internal helper for individual category item UI
  Widget _buildCategoryItem({
    required String name,
    required Color bgColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector( // Make it tappable
      onTap: onTap,
      child: Container(
        width: 80, // Fixed width for each item
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.grey.shade700, size: 30), // Icon inside the colored box
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(fontSize: 14),
              maxLines: 1, // Prevent text wrapping
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}