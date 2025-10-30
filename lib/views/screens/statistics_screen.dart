// lib/views/screens/statistics_screen.dart

import 'package:flutter/material.dart';
// Import controller
import '../../controllers/statistics_controller.dart';
// Import widget-widget
import '../widgets/statistics/calorie_detail_content.dart';
import '../widgets/statistics/weight_detail_content.dart';
import '../widgets/statistics/macro_detail_content.dart';
import '../widgets/statistics/water_detail_content.dart';
import '../widgets/shared/section_title.dart';
import '../widgets/statistics/summary/weight_progress_card.dart'; // Diperlukan untuk Ringkasan
import '../widgets/statistics/summary/calorie_intake_card.dart';
import '../widgets/statistics/summary/macro_breakdown_card.dart';
import '../widgets/statistics/detail/detail_category_tile.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late StatisticsController _controller; // Deklarasi controller

  // --- Data Dummy dan Logika telah dipindah ke StatisticsController ---

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller
    _controller = StatisticsController();
    _tabController = TabController(length: 2, vsync: this);

    // Tambahkan listener untuk TabController
    _tabController.addListener(_handleTabChange);

    // (Opsional) Tambahkan listener untuk SnackBar error dari controller
    _controller.addListener(_handleControllerChanges);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _controller.removeListener(_handleControllerChanges);
    _tabController.dispose();
    _controller.dispose(); // Dispose controller
    super.dispose();
  }

  // Listener untuk TabController (memanggil controller)
  void _handleTabChange() {
    _controller.handleTabChange(_tabController);
  }

  // (Opsional) Listener untuk SnackBar
  void _handleControllerChanges() {
    if (_controller.status == StatisticsStatus.failure &&
        _controller.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_controller.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  // --- Logika _handleBackButton & _onDetailCategoryTap dipindah ke controller ---

  @override
  Widget build(BuildContext context) {
    // Gunakan ListenableBuilder untuk me-render UI berdasarkan state controller
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        // Tentukan apakah tombol back harus ditampilkan
        bool showBackButton = _controller.selectedDetailCategory != null ||
            _tabController.index != 0;

        return Scaffold(
          // Background berbeda tergantung state
          backgroundColor: _controller.selectedDetailCategory == null
              ? Colors.grey[100]
              : Colors.white,
          appBar: AppBar(
            // Tombol back dinamis
            leading: showBackButton
                ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black54, size: 20),
              // Panggil controller
              onPressed: () =>
                  _controller.handleBackButton(_tabController, context),
            )
                : null,
            title: Text(
              // Judul AppBar dinamis dari controller
              _controller.selectedDetailCategory != null
                  ? 'Detail ${_controller.selectedDetailCategory}'
                  : 'Statistik',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 18),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            shadowColor: Colors.grey.shade200,
            // Tampilkan TabBar hanya jika tidak sedang di halaman detail
            bottom: _controller.selectedDetailCategory == null
                ? TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Ringkasan'),
                Tab(text: 'Detail'),
              ],
            )
                : null,
          ),
          body: _buildBodyContent(), // Panggil builder body
        );
      },
    );
  }

  /// Membangun body utama berdasarkan status controller
  Widget _buildBodyContent() {
    switch (_controller.status) {
      case StatisticsStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case StatisticsStatus.failure:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                Text(
                  _controller.errorMessage ?? 'Gagal memuat data.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  onPressed: _controller.fetchData,
                ),
              ],
            ),
          ),
        );
      case StatisticsStatus.success:
      default:
      // Tampilkan TabBarView jika data sukses
        return TabBarView(
          controller: _tabController,
          // Nonaktifkan swipe antar tab saat di halaman detail spesifik
          physics: _controller.selectedDetailCategory == null
              ? null
              : const NeverScrollableScrollPhysics(),
          children: [
            _buildSummaryTab(), // Builder untuk Tab Ringkasan
            _buildDetailTab(), // Builder untuk Tab Detail
          ],
        );
    }
  }

  // === WIDGET BUILDER UNTUK TAB RINGKASAN ===
  Widget _buildSummaryTab() {
    // Ambil data dari controller
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Catatan: WeightProgressCard ada di file asli tapi tidak ada di layout `statistics_screen`
          // Saya tambahkan di sini agar sesuai dengan file widget yang ada.
          // Hapus jika tidak diinginkan.
          const SectionTitle('Progres Berat Badan'),
          WeightProgressCard(
            currentWeight: _controller.currentWeight,
            weightChangePercent: _controller.weightChangePercent,
            weightPeriod: _controller.weightPeriod,
            weightSpots: _controller.weightSpots,
          ),
          const SizedBox(height: 25),

          const SectionTitle('Asupan Kalori'),
          CalorieIntakeCard(
            caloriesToday: _controller.caloriesToday,
            calorieChangePercent: _controller.calorieChangePercent,
            calorieDataPerMeal: _controller.calorieDataPerMeal,
            maxCaloriePerMeal: _controller.maxCaloriePerMeal,
          ),
          const SizedBox(height: 25),

          const SectionTitle('Rincian Makronutrien'),
          MacroBreakdownCard(
            macroRatio: _controller.macroRatio,
            macroChangePercent: _controller.macroChangePercent,
            macroDataPercentage: _controller.macroDataPercentage,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB DETAIL ===
  Widget _buildDetailTab() {
    // Jika belum ada kategori detail yang dipilih, tampilkan daftar
    if (_controller.selectedDetailCategory == null) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 24.0),
        itemCount: _controller.detailCategories.length,
        itemBuilder: (context, index) {
          final category = _controller.detailCategories[index];
          return DetailCategoryTile(
            title: category['title'],
            icon: category['icon'],
            // Panggil method controller saat di-tap
            onTap: () => _controller.onDetailCategoryTap(category['title']),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 18),
      );
    }
    // Jika ada kategori detail yang dipilih, tampilkan konten detailnya
    else {
      Widget detailContent;
      // Tentukan konten berdasarkan state controller
      switch (_controller.selectedDetailCategory) {
        case 'Kalori':
          detailContent = const CalorieDetailContent();
          break;
        case 'Makronutrien':
          detailContent = const MacroDetailContent();
          break;
        case 'Asupan Air':
          detailContent = const WaterDetailContent();
          break;
        case 'Berat Badan':
          detailContent = const WeightDetailContent();
          break;
        default:
          detailContent = const Center(child: Text('Konten detail tidak ditemukan'));
      }
      // Bungkus konten detail dengan SingleChildScrollView
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: detailContent,
      );
    }
  }
}