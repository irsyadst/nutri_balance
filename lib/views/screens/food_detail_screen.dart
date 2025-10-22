import 'package:flutter/material.dart';
import '../../models/meal_models.dart';

class FoodDetailScreen extends StatelessWidget {
  final MealItem mealItem;
  
  // Data resep statis untuk demonstrasi layout yang kompleks
  static final List<Map<String, String>> ingredients = [
    {'name': 'Tepung Terigu', 'amount': '100gr', 'icon': 'terigu'},
    {'name': 'Gula', 'amount': '3 sdm', 'icon': 'gula'},
    {'name': 'Baking Soda', 'amount': '2 sdt', 'icon': 'baking_soda'},
    {'name': 'Telur', 'amount': '2 item', 'icon': 'telur'},
  ];

  static final List<String> steps = [
    'Siapkan semua bahan yang dibutuhkan.',
    'Campur tepung, gula, garam, dan baking powder.',
    'Di tempat terpisah, campur telur dan susu hingga tercampur rata.',
    'Masukkan campuran telur dan susu ke dalam bahan kering hingga tercampur.',
    'Panaskan wajan dengan sedikit mentega.',
    'Tuang adonan pancake ke wajan sesuai ukuran yang diinginkan.',
    'Balik pancake setelah muncul gelembung.',
    'Sajikan pancake dengan siraman madu dan beri topping blueberry.'
  ];

  const FoodDetailScreen({super.key, required this.mealItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header & Heart Icon
                      _buildHeaderAndIcon(),
                      const SizedBox(height: 20),

                      // Nutrisi
                      const Text('Nutrisi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildNutritionChips(),
                      const SizedBox(height: 20),

                      // Deskripsi
                      const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _buildDescriptionText(),
                      const SizedBox(height: 30),

                      // Bahan-Bahan
                      _buildIngredientsSection(),
                      const SizedBox(height: 30),

                      // Langkah-Langkah
                      _buildStepsSection(),
                      const SizedBox(height: 100), // Ruang untuk tombol bawah
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Tombol Mengambang di bagian bawah
      bottomSheet: _buildFloatingActionButton(context),
    );
  }

  // === WIDGET PEMBANGUN (BUILDERS) ===

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
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
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.zero,
        background: Center(
          child: Container(
            // Placeholder Gambar Makanan
            color: Colors.grey.shade200, // Warna latar belakang gambar
            child: const Icon(Icons.cake, size: 200, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAndIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mealItem.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text('by Ikrom Nur', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ),
        // Icon Hati (Favorit)
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Color(0xFFEF5350), size: 28),
        ),
      ],
    );
  }

  Widget _buildNutritionChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            '${mealItem.calories} kkal', 
            const Color(0xFFEF5350).withOpacity(0.1), 
            const Color(0xFFEF5350), 
            Icons.local_fire_department
          ),
          _buildChip(
            '${mealItem.fat}g lemak', 
            const Color(0xFFFFC107).withOpacity(0.1), 
            const Color(0xFFFFC107), 
            Icons.egg_alt
          ),
          _buildChip(
            '${mealItem.protein}g protein', 
            const Color(0xFF007BFF).withOpacity(0.1), 
            const Color(0xFF007BFF), 
            Icons.set_meal
          ),
          // Tambahkan chip Karbohidrat jika diperlukan
          _buildChip(
            '${mealItem.carbs}g karbo', 
            const Color(0xFF4CAF50).withOpacity(0.1), 
            const Color(0xFF4CAF50), 
            Icons.local_florist
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDescriptionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealItem.description, // Gunakan deskripsi dari model
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        TextButton(
          onPressed: () {
            // Logika Baca Selengkapnya
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Baca Selengkapnya...', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Bahan-Bahan Yang Anda Butuhkan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${ingredients.length} item', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final item = ingredients[index];
              return _buildIngredientCard(item['name']!, item['amount']!);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientCard(String name, String amount) {
    // Placeholder warna dan ikon untuk bahan
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.egg, size: 30, color: Colors.brown),
          const SizedBox(height: 5),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Step by Step', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${steps.length} Steps', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return _buildTimelineStep(context, index + 1, steps[index], index < 5); // Hanya 5 langkah pertama yang terlihat 'active' di gambar
          },
        ),
      ],
    );
  }

  Widget _buildTimelineStep(BuildContext context, int stepNumber, String description, bool isActive) {
    const activeColor = Color(0xFF007BFF);
    final color = isActive ? activeColor : Colors.grey.shade400;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Marker
          Column(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                  color: isActive ? Colors.white : Colors.white,
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString().padLeft(2, '0'), // Format 01, 02, etc
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ),
              if (stepNumber < steps.length)
                Container(
                  width: 2,
                  height: 60, // Jarak antar step
                  color: color,
                ),
            ],
          ),
          const SizedBox(width: 20),
          // Step Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Step $stepNumber', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 16, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Aksi Tambahkan ke Makanan Sarapan
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${mealItem.name} ditambahkan ke Sarapan!')));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007BFF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text('Tambahkan ke Makanan Sarapan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}