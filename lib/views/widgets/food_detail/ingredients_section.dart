import 'package:flutter/material.dart';

class IngredientsSection extends StatelessWidget {
  final List<Map<String, String>> ingredients;

  const IngredientsSection({
    super.key,
    required this.ingredients,
  });

  // Helper untuk mendapatkan ikon berdasarkan nama (bisa diperluas)
  IconData _getIngredientIcon(String name) {
    String lowerName = name.toLowerCase();
    if (lowerName.contains('tepung') || lowerName.contains('gandum')) return Icons.grain;
    if (lowerName.contains('gula') || lowerName.contains('madu')) return Icons.icecream_outlined;
    if (lowerName.contains('telur')) return Icons.egg_outlined;
    if (lowerName.contains('susu') || lowerName.contains('yogurt')) return Icons.opacity; // Tetesan
    if (lowerName.contains('mentega') || lowerName.contains('minyak')) return Icons.water_drop_outlined;
    if (lowerName.contains('garam')) return Icons.scatter_plot_outlined; // Contoh
    if (lowerName.contains('baking') || lowerName.contains('ragi')) return Icons.bubble_chart_outlined;
    if (lowerName.contains('buah') || lowerName.contains('berry')) return Icons.apple;
    return Icons.food_bank_outlined; // Default
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Bahan-Bahan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${ingredients.length} item', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100, // Tinggi tetap untuk list horizontal
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final item = ingredients[index];
              final icon = _getIngredientIcon(item['name'] ?? '');
              return _buildIngredientCard(
                name: item['name'] ?? 'Unknown',
                amount: item['amount'] ?? '-',
                icon: icon,
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget internal untuk kartu bahan
  Widget _buildIngredientCard({required String name, required String amount, required IconData icon}) {
    return Container(
      width: 90, // Lebar kartu
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Background abu-abu
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten
        children: [
          Icon(icon, size: 30, color: Colors.grey.shade700), // Ikon bahan
          const SizedBox(height: 5),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center,),
          const SizedBox(height: 2),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            maxLines: 2, // Maksimal 2 baris
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}