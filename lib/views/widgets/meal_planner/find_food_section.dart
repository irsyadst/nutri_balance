import 'package:flutter/material.dart';
import '../../screens/food_category_screen.dart'; // For navigation

// Section "Find Something to Eat" with horizontal category cards
class FindFoodSection extends StatelessWidget {
  const FindFoodSection({super.key});

  // Example category data (could be passed in)
  final List<Map<String, dynamic>> categories = const [
    { 'title': 'Sarapan', 'subtitle': '120+ Makanan', 'bgColor': const Color(0xFFE7F3FF), 'btnColor': const Color(0xFF007BFF) },
    { 'title': 'Makan siang', 'subtitle': '130+ Makanan', 'bgColor': const Color(0xFFF3E5F5), 'btnColor': const Color(0xFF9C27B0) },
    { 'title': 'Makan Malam', 'subtitle': '90+ Makanan', 'bgColor': const Color(0xFFE8F5E9), 'btnColor': const Color(0xFF4CAF50) },
    { 'title': 'Snack', 'subtitle': '80+ Makanan', 'bgColor': const Color(0xFFFFF3E0), 'btnColor': const Color(0xFFFF9800) },
    // Add more categories
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cari Sesuatu Untuk Dimakan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Adjusted Title
        const SizedBox(height: 15),
        SizedBox(
          height: 200, // Fixed height for the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _FoodCategoryCard( // Use internal helper widget
                title: cat['title'] as String,
                subtitle: cat['subtitle'] as String,
                bgColor: cat['bgColor'] as Color,
                btnColor: cat['btnColor'] as Color,
                onTap: () {
                  // Navigate to FoodCategoryScreen when card button is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodCategoryScreen(mealType: cat['title'] as String)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


// --- Internal Widget for the Category Card ---
class _FoodCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color btnColor;
  final VoidCallback onTap;

  const _FoodCategoryCard({
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.btnColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Width of each card
      margin: const EdgeInsets.only(right: 15), // Space between cards
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
        children: [
          // Image Placeholder
          Container(
            width: double.infinity,
            height: 80, // Adjust height
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // Placeholder background
                borderRadius: BorderRadius.circular(15)
            ),
            child: Icon(Icons.restaurant_menu, size: 40, color: btnColor.withOpacity(0.6)), // Placeholder icon
            // child: Image.asset( ... ), // Use if you have specific images
          ),
          // Category Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), // Slightly smaller
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[700])), // Darker grey
            ],
          ),
          // Select Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap, // Use the provided callback
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor, // Use button color
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0, // No shadow for this button style
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: const Text('Select', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}