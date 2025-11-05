// lib/views/screens/statistics_screen.dart

import 'package:flutter/material.dart';
// Import controller
import '../../controllers/statistics_controller.dart';
// Import widget-widget
import '../widgets/statistics/calorie_detail_content.dart';
import '../widgets/statistics/macro_detail_content.dart';
import '../widgets/statistics/water_detail_content.dart';
import '../widgets/shared/section_title.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = StatisticsController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _controller.addListener(_handleControllerChanges);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _controller.removeListener(_handleControllerChanges);
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    _controller.handleTabChange(_tabController);
  }

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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        bool showBackButton = _controller.selectedDetailCategory != null ||
            _tabController.index != 0;

        return Scaffold(
          backgroundColor: _controller.selectedDetailCategory == null
              ? Colors.grey[100]
              : Colors.white,
          appBar: AppBar(
            leading: showBackButton
                ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black54, size: 20),
              onPressed: () =>
                  _controller.handleBackButton(_tabController, context),
            )
                : null,
            title: Text(
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
          body: _buildBodyContent(),
        );
      },
    );
  }

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
        return TabBarView(
          controller: _tabController,
          physics: _controller.selectedDetailCategory == null
              ? null
              : const NeverScrollableScrollPhysics(),
          children: [
            _buildSummaryTab(),
            _buildDetailTab(),
          ],
        );
    }
  }

  // === WIDGET BUILDER UNTUK TAB RINGKASAN ===
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BLOK BERAT BADAN DIHAPUS DARI SINI ---

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
    if (_controller.selectedDetailCategory == null) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 24.0),
        itemCount: _controller.detailCategories.length,
        itemBuilder: (context, index) {
          final category = _controller.detailCategories[index];
          return DetailCategoryTile(
            title: category['title'],
            icon: category['icon'],
            onTap: () => _controller.onDetailCategoryTap(category['title']),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 18),
      );
    } else {
      Widget detailContent;
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
      // --- CASE 'BERAT BADAN' DIHAPUS DARI SINI ---
        default:
          detailContent =
          const Center(child: Text('Konten detail tidak ditemukan'));
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: detailContent,
      );
    }
  }
}