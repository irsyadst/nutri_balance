import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'daily_summary_screen.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Controller form Tambah Manual
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _servingSizeController = TextEditingController();

  // Data Dummy
  final List<String> recentFoods = ['Dada ayam', 'Beras merah', 'Brokoli', 'Alpukat', 'Ikan salmon'];
  final List<Map<String, dynamic>> categories = [
    {'name': 'Salad', 'icon': Icons.spa_outlined},
    {'name': 'Buah-buahan', 'icon': Icons.apple_outlined},
    {'name': 'Sayuran', 'icon': Icons.local_florist_outlined},
    {'name': 'Daging', 'icon': Icons.kebab_dining_outlined},
    {'name': 'Produk susu', 'icon': Icons.egg_alt_outlined},
    {'name': 'Biji-bijian', 'icon': Icons.grain_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _foodNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _servingSizeController.dispose();
    super.dispose();
  }

  // Fungsi submit form Tambah Manual
  void _submitManualFood() async { // <-- Tambahkan async jika proses simpan butuh await
    if (_formKey.currentState!.validate()) {
      // Form valid
      final foodName = _foodNameController.text;
      final calories = int.tryParse(_caloriesController.text) ?? 0;
      final protein = int.tryParse(_proteinController.text) ?? 0;
      final carbs = int.tryParse(_carbsController.text) ?? 0;
      final fat = int.tryParse(_fatController.text) ?? 0;
      final servingSize = _servingSizeController.text;

      print('Nama Makanan: $foodName');
      print('Kalori: $calories kkal');
      print('Protein: $protein g');
      print('Karbohidrat: $carbs g');
      print('Lemak: $fat g');
      print('Ukuran Porsi: $servingSize');

      // --- SIMULASI PROSES SIMPAN (Ganti dengan kode asli Anda) ---
      print('Menyimpan data...');
      // TODO: Ganti ini dengan logika penyimpanan ke backend/state management
      // Misalnya: bool success = await FoodController.saveFood(...);
      await Future.delayed(const Duration(seconds: 1)); // Simulasi delay
      bool success = true; // Anggap sukses untuk contoh ini
      // --- AKHIR SIMULASI ---

      // Penting: Cek 'mounted' sebelum melakukan navigasi atau menampilkan SnackBar
      if (!mounted) return;

      if (success) {
        // --- NAVIGASI DITAMBAHKAN DI SINI ---
        Navigator.pushReplacement( // Ganti layar saat ini dengan DailySummaryScreen
          context,
          MaterialPageRoute(builder: (context) => const DailySummaryScreen()),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan makanan.')),
        );
      }
    } else {
      // Form tidak valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom dengan benar.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Tambah Makanan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Rekomendasi'),
            Tab(text: 'Tambah Manual'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecommendationTab(context),
          _buildManualAddTab(context),
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB REKOMENDASI ===
  Widget _buildRecommendationTab(BuildContext context) {
    // ... (Kode untuk tab rekomendasi - tidak berubah) ...
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 25),
          const Text('Terkini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: recentFoods.map((food) => _buildRecentFoodChip(food)).toList(),
          ),
          const SizedBox(height: 30),
          const Text('Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildCategoryGrid(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    // ... (Kode search bar - tidak berubah) ...
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Cari makanan',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFF3F4F6), // Warna abu muda
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onChanged: (value) {
        // TODO: Implementasi logika pencarian
        print('Mencari: $value');
      },
    );
  }

  Widget _buildRecentFoodChip(String foodName) {
    // ... (Kode chip - tidak berubah) ...
    return Chip(
      label: Text(foodName, style: TextStyle(color: Colors.grey.shade700)),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    // ... (Kode grid kategori - tidak berubah) ...
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          context,
          category['name'],
          category['icon'],
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, String name, IconData icon) {
    // ... (Kode kartu kategori - tidak berubah) ...
    return InkWell( // Bungkus dengan InkWell agar bisa diklik
      onTap: () {
        // TODO: Navigasi ke halaman detail kategori atau lakukan aksi lain
        print('Kategori diklik: $name');
      },
      borderRadius: BorderRadius.circular(15), // Efek ripple mengikuti bentuk
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Placeholder untuk gambar kategori (ganti dengan Image.asset jika ada)
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade100,
              child: Icon(icon, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Expanded( // Agar teks tidak overflow
              child: Text(
                name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis, // Atasi jika teks terlalu panjang
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB TAMBAH MANUAL ===
  Widget _buildManualAddTab(BuildContext context) {
    // ... (Kode tab manual - tidak berubah) ...
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: Form( // Bungkus dengan Form
        key: _formKey, // Gunakan GlobalKey
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Agar tombol lebar penuh
          children: [
            // Field Nama Makanan
            _buildManualTextField(
              controller: _foodNameController,
              hintText: 'Nama Makanan',
              validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 15),

            // Field Kalori
            _buildManualTextField(
              controller: _caloriesController,
              hintText: 'Kalori',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Hanya angka
              validator: (value) => value == null || value.isEmpty ? 'Kalori tidak boleh kosong' : null,
            ),
            const SizedBox(height: 15),

            // Field Protein & Karbohidrat (dalam satu baris)
            Row(
              children: [
                Expanded(
                  child: _buildManualTextField(
                    controller: _proteinController,
                    hintText: 'Protein',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value == null || value.isEmpty ? 'Protein tidak boleh kosong' : null,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildManualTextField(
                    controller: _carbsController,
                    hintText: 'Karbohidrat',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value == null || value.isEmpty ? 'Karbohidrat tidak boleh kosong' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Field Lemak & Ukuran Porsi (dalam satu baris)
            Row(
              children: [
                Expanded(
                  child: _buildManualTextField(
                    controller: _fatController,
                    hintText: 'Lemak',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value == null || value.isEmpty ? 'Lemak tidak boleh kosong' : null,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildManualTextField(
                    controller: _servingSizeController,
                    hintText: 'Ukuran Porsi', // Misal: 100g, 1 mangkok
                    validator: (value) => value == null || value.isEmpty ? 'Ukuran porsi tidak boleh kosong' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40), // Jarak sebelum tombol

            // Tombol Tambahkan Makanan
            ElevatedButton.icon(
              onPressed: _submitManualFood, // Panggil fungsi submit
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambahkan Makanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // Warna biru
                minimumSize: const Size(double.infinity, 55), // Lebar penuh
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk TextField di tab manual
  Widget _buildManualTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    // ... (Kode text field - tidak berubah) ...
    return TextFormField( // Gunakan TextFormField untuk validasi
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator, // Terapkan validator
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // Styling untuk error
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}