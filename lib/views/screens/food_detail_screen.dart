import 'package:flutter/material.dart';
import '../../models/meal_models.dart';
// Import widget yang baru dibuat
import '../widgets/food_detail/food_detail_app_bar.dart';
import '../widgets/food_detail/food_detail_header.dart';
import '../widgets/food_detail/nutrition_info_chips.dart';
import '../widgets/food_detail/food_description.dart';
import '../widgets/food_detail/ingredients_section.dart';
import '../widgets/food_detail/instructions_section.dart';
import '../widgets/food_detail/add_to_meal_button.dart';


class FoodDetailScreen extends StatefulWidget { // Ubah ke StatefulWidget untuk state isFavorite
  final MealItem mealItem;

  // Data resep statis (bisa dipindah ke model atau service)
  static final List<Map<String, String>> ingredients = [
    {'name': 'Tepung Terigu', 'amount': '100gr'},
    {'name': 'Gula', 'amount': '3 sdm'},
    {'name': 'Baking Soda', 'amount': '2 sdt'},
    {'name': 'Telur', 'amount': '2 item'},
    // Tambahkan bahan lain jika perlu
  ];

  static final List<String> steps = [
    'Siapkan semua bahan...',
    'Campur tepung...',
    'Di tempat terpisah...',
    'Masukkan campuran telur...',
    'Panaskan wajan...',
    'Tuang adonan...',
    'Balik pancake...',
    'Sajikan...',
  ];

  const FoodDetailScreen({super.key, required this.mealItem});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  bool _isFavorite = false; // State untuk status favorit

  // Fungsi untuk toggle favorit
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      // TODO: Tambahkan logika untuk menyimpan status favorit (misal ke database/shared_prefs)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isFavorite ? '${widget.mealItem.name} ditambahkan ke favorit' : '${widget.mealItem.name} dihapus dari favorit')),
      );
    });
  }

  // Fungsi untuk tombol Add to Meal
  void _handleAddToMeal() {
    // TODO: Implementasikan logika menambahkan makanan ke jadwal makan
    // Anda mungkin perlu tahu meal type (Sarapan, dll.) di sini
    String targetMeal = "Sarapan"; // Contoh, bisa didapat dari parameter atau state
    print('${widget.mealItem.name} ditambahkan ke $targetMeal!');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.mealItem.name} ditambahkan ke $targetMeal! (Logika Belum Ada)')),
    );
    // Mungkin navigasi kembali atau update state
    // Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Gunakan Stack agar tombol AddToMealButton bisa mengambang di atas konten
      body: Stack(
        children: [
          CustomScrollView( // Konten utama yang bisa di-scroll
            slivers: [
              // Gunakan FoodDetailAppBar
              FoodDetailAppBar(mealItem: widget.mealItem),

              // Konten di bawah AppBar
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), // Padding utama
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gunakan FoodDetailHeader
                          FoodDetailHeader(
                            foodName: widget.mealItem.name,
                            isFavorite: _isFavorite,
                            onFavoriteTap: _toggleFavorite, // Panggil toggle
                            // authorName: widget.mealItem.author, // Jika ada
                          ),
                          const SizedBox(height: 25),

                          // Gunakan NutritionInfoChips
                          const Text('Nutrisi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          NutritionInfoChips(
                            calories: widget.mealItem.calories,
                            protein: widget.mealItem.protein,
                            fat: widget.mealItem.fat,
                            carbs: widget.mealItem.carbs,
                          ),
                          const SizedBox(height: 25),

                          // Gunakan FoodDescription
                          const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          FoodDescription(description: widget.mealItem.description),
                          const SizedBox(height: 30),

                          // Gunakan IngredientsSection
                          IngredientsSection(ingredients: FoodDetailScreen.ingredients),
                          const SizedBox(height: 30),

                          // Gunakan InstructionsSection
                          InstructionsSection(steps: FoodDetailScreen.steps),

                          // Beri ruang di bagian bawah agar tidak tertutup tombol
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Tombol AddToMealButton di bagian bawah
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AddToMealButton(
                mealName: "Sarapan", // Ganti sesuai konteks atau biarkan statis
                onPressed: _handleAddToMeal,
              )
          ),
        ],
      ),
      // Hapus bottomSheet karena sudah diganti dengan Positioned di dalam Stack
      // bottomSheet: _buildFloatingActionButton(context),
    );
  }
}