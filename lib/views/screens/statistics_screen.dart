import 'package:flutter/material.dart';
// Hapus import yang tidak perlu lagi di sini (fl_chart, intl, dart:math)
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
// import 'dart:math';
import 'package:fl_chart/fl_chart.dart';

// Import detail content widgets (ini sudah ada sebelumnya)
import '../widgets/statistics/calorie_detail_content.dart';
import '../widgets/statistics/weight_detail_content.dart';
import '../widgets/statistics/macro_detail_content.dart';
import '../widgets/statistics/water_detail_content.dart';
// Import widget-widget baru
import '../widgets/shared/section_title.dart';
import '../widgets/statistics/summary/weight_progress_card.dart';
import '../widgets/statistics/summary/calorie_intake_card.dart';
import '../widgets/statistics/summary/macro_breakdown_card.dart';
import '../widgets/statistics/detail/detail_category_tile.dart';


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedDetailCategory; // State untuk kategori detail yang dipilih

  // --- Data Dummy (Pindahkan ke Controller/State Management nantinya) ---
  final double currentWeight = 68.5; // Contoh
  final double weightChangePercent = -1.2;
  final String weightPeriod = "7 Hari Terakhir";
  final int caloriesToday = 1850;
  final double calorieChangePercent = -3.5;
  final String macroRatio = "45/30/25";
  final double macroChangePercent = 2.1;

  final List<FlSpot> weightSpots = [ // <-- REMOVE 'const'
    FlSpot(0, 70), FlSpot(1, 69.8), FlSpot(2, 69.5), FlSpot(3, 69.6),
    FlSpot(4, 69.2), FlSpot(5, 68.8), FlSpot(6, 68.5),
  ];
  final Map<String, double> calorieData = const {
    'Sarapan': 450, 'Makan Siang': 600, 'Makan Malam': 550, 'Snack': 250,
  };
  final double maxCaloriePerMeal = 700; // Contoh batas atas kalori per meal
  final Map<String, double> macroData = const {
    'Karbohidrat': 45, 'Protein': 30, 'Lemak': 25,
  };
  // --- Akhir Data Dummy ---


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Tambahkan listener untuk mereset _selectedDetailCategory saat kembali ke tab Ringkasan
    _tabController.addListener(_handleTabChange);
    // _fetchStatisticsData(); // Panggil fetch data jika diperlukan
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange); // Hapus listener
    _tabController.dispose();
    super.dispose();
  }

  // Listener untuk TabController
  void _handleTabChange() {
    // Jika user kembali ke tab Ringkasan (index 0) dari tab Detail
    if (_tabController.index == 0 && _selectedDetailCategory != null) {
      setState(() {
        _selectedDetailCategory = null; // Reset pilihan kategori detail
      });
    }
    // Optional: Fetch data based on tab index if needed
    // if (!_tabController.indexIsChanging) { ... fetch data ... }
  }


  // Fungsi Fetch Data (contoh)

  // Fungsi untuk menangani tap pada kategori detail
  void _onDetailCategoryTap(String category) {
    setState(() {
      _selectedDetailCategory = category;
    });
  }

  // Fungsi untuk tombol back di AppBar
  void _handleBackButton() {
    if (_selectedDetailCategory != null) {
      // Jika sedang di halaman detail, kembali ke daftar kategori detail
      setState(() {
        _selectedDetailCategory = null;
      });
    } else if (_tabController.index != 0) {
      // Jika sedang di tab Detail (tapi bukan di halaman detail spesifik),
      // kembali ke tab Ringkasan
      _tabController.animateTo(0);
    } else if (Navigator.canPop(context)) {
      // Jika sudah di tab Ringkasan, keluar dari layar Statistik
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Tentukan apakah tombol back harus ditampilkan
    bool showBackButton = _selectedDetailCategory != null || _tabController.index != 0;

    return Scaffold(
      // Background berbeda tergantung state
      backgroundColor: _selectedDetailCategory == null ? Colors.grey[100] : Colors.white,
      appBar: AppBar(
        // Tombol back dinamis
        leading: showBackButton
            ? IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54, size: 20),
          onPressed: _handleBackButton, // Panggil handler back
        )
            : null, // Sembunyikan jika tidak perlu
        title: Text(
          // Judul AppBar dinamis
          _selectedDetailCategory != null ? 'Detail $_selectedDetailCategory' : 'Statistik',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // AppBar selalu putih
        elevation: 0.5, // Shadow tipis konsisten
        shadowColor: Colors.grey.shade200,
        // Tampilkan TabBar hanya jika tidak sedang di halaman detail spesifik
        bottom: _selectedDetailCategory == null
            ? TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          tabs: const [ Tab(text: 'Ringkasan'), Tab(text: 'Detail'), ],
        )
            : null, // Sembunyikan TabBar saat di detail
      ),
      body: TabBarView(
        controller: _tabController,
        // Nonaktifkan swipe antar tab saat di halaman detail spesifik
        physics: _selectedDetailCategory == null ? null : const NeverScrollableScrollPhysics(),
        children: [
          _buildSummaryTab(), // Builder untuk Tab Ringkasan
          _buildDetailTab(),  // Builder untuk Tab Detail
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB RINGKASAN ===
  Widget _buildSummaryTab() {
    // Gunakan data dummy (ganti dengan data dari state/controller)
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gunakan SectionTitle
          const SectionTitle('Asupan Kalori'),
          // Gunakan CalorieIntakeCard
          CalorieIntakeCard(
            caloriesToday: caloriesToday,
            calorieChangePercent: calorieChangePercent,
            calorieDataPerMeal: calorieData, // Teruskan data kalori per meal
            maxCaloriePerMeal: maxCaloriePerMeal, // Teruskan batas maks
          ),
          const SizedBox(height: 25),

          const SectionTitle('Rincian Makronutrien'),
          // Gunakan MacroBreakdownCard
          MacroBreakdownCard(
            macroRatio: macroRatio,
            macroChangePercent: macroChangePercent,
            macroDataPercentage: macroData, // Teruskan data persentase makro
          ),
          const SizedBox(height: 20), // Padding bawah
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB DETAIL ===
  Widget _buildDetailTab() {
    // --- Daftar Kategori Detail ---
    // (Bisa jadi konstanta atau didapat dari state)
    final List<Map<String, dynamic>> detailCategories = [
      {'title': 'Kalori', 'icon': Icons.local_fire_department_outlined},
      {'title': 'Makronutrien', 'icon': Icons.pie_chart_outline_rounded}, // Ikon rounded
      {'title': 'Asupan Air', 'icon': Icons.water_drop_outlined},
      // Hapus 'Aktivitas'
    ];

    // Jika belum ada kategori detail yang dipilih, tampilkan daftar
    if (_selectedDetailCategory == null) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 24.0),
        itemCount: detailCategories.length,
        itemBuilder: (context, index) {
          final category = detailCategories[index];
          // Gunakan DetailCategoryTile
          return DetailCategoryTile(
            title: category['title'],
            icon: category['icon'],
            onTap: () => _onDetailCategoryTap(category['title']), // Panggil handler tap
          );
        },
        // Pemisah antar tile
        separatorBuilder: (context, index) => const SizedBox(height: 18),
      );
    }
    // Jika ada kategori detail yang dipilih, tampilkan konten detailnya
    else {
      Widget detailContent;
      // Tentukan konten berdasarkan _selectedDetailCategory
      switch (_selectedDetailCategory) {
        case 'Kalori': detailContent = const CalorieDetailContent(); break;
        case 'Makronutrien': detailContent = const MacroDetailContent(); break;
        case 'Asupan Air': detailContent = const WaterDetailContent(); break;
      // Hapus case 'Aktivitas'
        default: detailContent = const Center(child: Text('Konten detail tidak ditemukan'));
      }
      // Bungkus konten detail dengan SingleChildScrollView
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: detailContent,
      );
    }
  }
}