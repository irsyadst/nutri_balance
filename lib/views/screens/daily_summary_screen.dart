import 'package:flutter/material.dart';
// TODO: Ganti path import ini sesuai struktur model Anda
// import '../../models/meal_models.dart'; // Jika FoodLogItem ada di sini
import 'add_food_screen.dart'; // Import layar tambah makanan

// --- Model Data Dummy (Ganti dengan model asli Anda) ---
// Jika Anda sudah punya model seperti FoodLogItem atau MealItem, gunakan itu.
// Pastikan model tersebut memiliki properti yang dibutuhkan (name, serving, calories, protein, carbs, fat, imageUrl).
class FoodLogItem {
  final String name;
  final String serving;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String imageUrl; // URL atau path aset gambar

  const FoodLogItem({
    required this.name,
    required this.serving,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl, // Pastikan path ini benar atau gunakan NetworkImage
  });
}
// --- Akhir Model Data Dummy ---


// --- Ubah menjadi StatefulWidget untuk handle refresh ---
class DailySummaryScreen extends StatefulWidget {
  const DailySummaryScreen({super.key});

  @override
  State<DailySummaryScreen> createState() => _DailySummaryScreenState();
}

class _DailySummaryScreenState extends State<DailySummaryScreen> {

  // --- Data Dummy (Pindahkan ke dalam State) ---
  // TODO: Ganti ini dengan data asli yang diambil dari state/controller/API
  int totalCalories = 1850;
  int totalProtein = 120;
  int totalCarbs = 200;

  List<FoodLogItem> breakfastItems = const [
    FoodLogItem(name: 'Oatmeal dengan Berry', serving: '1 cangkir', calories: 250, protein: 20, carbs: 10, fat: 15, imageUrl: 'assets/images/oatmeal_placeholder.png'), // Ganti path gambar
    FoodLogItem(name: 'Roti Bakar Gandum Utuh', serving: '2 potong', calories: 150, protein: 5, carbs: 20, fat: 5, imageUrl: 'assets/images/toast_placeholder.png'), // Ganti path gambar
  ];
  List<FoodLogItem> lunchItems = const [
    FoodLogItem(name: 'Salad Ayam Panggang', serving: '1 porsi', calories: 400, protein: 30, carbs: 40, fat: 10, imageUrl: 'assets/images/salad_placeholder.png'), // Ganti path gambar
  ];
  List<FoodLogItem> dinnerItems = const [
    FoodLogItem(name: 'Salmon dengan Sayuran Panggang', serving: '1 porsi', calories: 500, protein: 40, carbs: 50, fat: 20, imageUrl: 'assets/images/salmon_placeholder.png'), // Ganti path gambar
  ];
  List<FoodLogItem> snackItems = const [
    FoodLogItem(name: 'Yoghurt Yunani', serving: '1 cangkir', calories: 100, protein: 10, carbs: 5, fat: 5, imageUrl: 'assets/images/yogurt_placeholder.png'), // Ganti path gambar
    FoodLogItem(name: 'Apel', serving: '1 apel', calories: 150, protein: 1, carbs: 30, fat: 0, imageUrl: 'assets/images/apple_placeholder.png'), // Ganti path gambar
  ];
  // --- Akhir Data Dummy ---

  @override
  void initState() {
    super.initState();
    _fetchData(); // Panggil fungsi untuk memuat data awal
  }

  // Fungsi untuk memuat data (ganti dengan logika asli Anda)
  Future<void> _fetchData() async {
    print("Memuat data DailySummaryScreen...");
    // TODO: Ganti ini dengan logika mengambil data dari backend/controller
    // Misalnya:
    // final summaryData = await ApiService.getDailySummary(tanggalTerpilih); // Anda mungkin perlu tanggal
    // final mealLogs = await ApiService.getMealLogs(tanggalTerpilih);
    // setState(() {
    //   totalCalories = summaryData.calories;
    //   totalProtein = summaryData.protein;
    //   totalCarbs = summaryData.carbs;
    //   breakfastItems = mealLogs.where((log) => log.mealType == 'Sarapan').map((apiItem) => FoodLogItem(...)).toList();
    //   lunchItems = mealLogs.where((log) => log.mealType == 'Makan Siang').map((apiItem) => FoodLogItem(...)).toList();
    //   dinnerItems = mealLogs.where((log) => log.mealType == 'Makan Malam').map((apiItem) => FoodLogItem(...)).toList();
    //   snackItems = mealLogs.where((log) => log.mealType == 'Makanan Ringan').map((apiItem) => FoodLogItem(...)).toList();
    // });
    await Future.delayed(const Duration(milliseconds: 100)); // Simulasi delay network
    // Untuk contoh ini, kita tidak perlu setState karena data dummy sudah ada
    print("Data (dummy) siap.");
  }


  // Fungsi helper untuk navigasi ke AddFoodScreen dan menangani refresh
  void _navigateToAddFood(BuildContext context, String mealType) async {
    final result = await Navigator.push<bool>( // Tunggu hasil (true jika ada penambahan)
      context,
      MaterialPageRoute(
          builder: (context) => AddFoodScreen(/* TODO: Pass mealType jika AddFoodScreen menerimanya, misal: selectedMeal: mealType */)
      ),
    );

    // Cek hasil setelah kembali dari AddFoodScreen
    if (result == true && mounted) { // 'mounted' check is good practice
      print("Kembali dari AddFoodScreen, memuat ulang data...");
      // Jika hasilnya true, panggil _fetchData untuk refresh tampilan
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Catatan Makanan Harian',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1, // Beri sedikit shadow
        shadowColor: Colors.grey.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Ringkasan
            const Text(
              'Ringkasan Hari Ini',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Kartu Makro - gunakan data dari state
            _buildMacroSummaryCards(totalCalories, totalProtein, totalCarbs),
            const SizedBox(height: 35),

            // Bagian Sarapan - gunakan data dari state
            _buildMealSection(
              context,
              title: 'Sarapan',
              items: breakfastItems,
              onAddFood: () => _navigateToAddFood(context, 'Sarapan'),
            ),
            const SizedBox(height: 30),

            // Bagian Makan Siang - gunakan data dari state
            _buildMealSection(
              context,
              title: 'Makan siang',
              items: lunchItems,
              onAddFood: () => _navigateToAddFood(context, 'Makan Siang'),
            ),
            const SizedBox(height: 30),

            // Bagian Makan Malam - gunakan data dari state
            _buildMealSection(
              context,
              title: 'Makan malam',
              items: dinnerItems,
              onAddFood: () => _navigateToAddFood(context, 'Makan Malam'),
            ),
            const SizedBox(height: 30),

            // Bagian Makanan Ringan - gunakan data dari state
            _buildMealSection(
              context,
              title: 'Makanan ringan',
              items: snackItems,
              onAddFood: () => _navigateToAddFood(context, 'Makanan Ringan'),
            ),
            const SizedBox(height: 20), // Padding bawah
          ],
        ),
      ),
    );
  }

  // === WIDGET BUILDER ===

  Widget _buildMacroSummaryCards(int calories, int protein, int carbs) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMacroCard('Jumlah Kalori', '$calories kkal')),
            const SizedBox(width: 15),
            Expanded(child: _buildMacroCard('Protein', '$protein gram')),
          ],
        ),
        const SizedBox(height: 15),
        // Karbohidrat full width sesuai gambar
        _buildMacroCard('Karbohidrat', '$carbs gram'),
      ],
    );
  }

  Widget _buildMacroCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Warna abu muda
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, {
    required String title,
    required List<FoodLogItem> items,
    required VoidCallback onAddFood,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        // Daftar item makanan
        if (items.isEmpty)
          Padding( // Beri padding agar tidak terlalu mepet
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
                'Belum ada makanan ditambahkan untuk $title.',
                style: const TextStyle(color: Colors.grey)
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) => _buildFoodItemTile(items[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          ),
        const SizedBox(height: 15),
        // Tombol Tambahkan Makanan
        Center( // Pusatkan tombol
          child: TextButton.icon(
            onPressed: onAddFood, // Panggil callback saat ditekan
            icon: Icon(Icons.add, color: Colors.grey.shade600, size: 20),
            label: Text(
              'Tambahkan Makanan',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF3F4F6), // Warna abu muda
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodItemTile(FoodLogItem item) {
    return Row(
      children: [
        // Gambar Makanan
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset( // TODO: Ganti ke Image.network jika URL dari API
            item.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            // Error builder jika gambar gagal load atau path salah
            errorBuilder: (context, error, stackTrace) {
              print("Error loading image: ${item.imageUrl}, Error: $error"); // Tambahkan log error
              return Container(
                width: 50, height: 50, color: Colors.grey.shade200,
                child: Icon(Icons.broken_image, color: Colors.grey.shade400), // Ikon error
              );
            },
          ),
        ),
        const SizedBox(width: 15),
        // Detail Teks
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 1, // Batasi 1 baris
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                // Tampilkan porsi dan kalori dulu
                '${item.serving} | ${item.calories} kkal',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
              // Tampilkan detail makro di baris baru jika perlu (agar tidak terlalu panjang)
              Text(
                'P: ${item.protein}g, K: ${item.carbs}g, L: ${item.fat}g', // Ganti K & L
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ],
    );
  }
}