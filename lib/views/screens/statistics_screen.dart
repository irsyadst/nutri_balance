// lib/views/screens/statistics_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/statistics_controller.dart';
import '../widgets/statistics/calorie_detail_content.dart';
import '../widgets/statistics/macro_detail_content.dart';
import '../widgets/shared/section_title.dart';
import '../widgets/statistics/summary/calorie_intake_card.dart';
import '../widgets/statistics/summary/macro_breakdown_card.dart';
import '../widgets/statistics/detail/detail_category_tile.dart';
import 'package:nutri_balance/models/api_service.dart';
import 'package:nutri_balance/models/storage_service.dart';


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late StatisticsController _controller;

  bool _isControllerInitialized = false;
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    _initializeController();
  }

  Future<void> _initializeController() async {
    final token = await _storage.getToken();

    if (token == null || token.isEmpty) {
      debugPrint("Token tidak ditemukan untuk StatisticsController");
      if (mounted) {
        setState(() {
          _isControllerInitialized = false;
        });
      }
      return;
    }

    _controller = StatisticsController(
      apiService: ApiService(),
      token: token,
    );

    _controller.addListener(_handleControllerChanges);

    if (mounted) {
      setState(() {
        _isControllerInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    if (_isControllerInitialized) {
      _controller.removeListener(_handleControllerChanges);
      _controller.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_isControllerInitialized) {
      _controller.handleTabChange(_tabController);
    }
  }

  void _handleControllerChanges() {
    if (_isControllerInitialized &&
        _controller.status == StatisticsStatus.failure &&
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
    if (!_isControllerInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Statistik')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterControls(),

          const SectionTitle('Asupan Kalori'),
          CalorieIntakeCard(
            caloriesToday: _controller.caloriesToday,
            calorieChangePercent: _controller.calorieChangePercent,
            calorieDataPerMeal: _controller.calorieDataPerMeal,
            maxCaloriePerMeal: _controller.maxCaloriePerMeal,
          ),

          const SectionTitle('Rincian Makronutrien'),
          MacroBreakdownCard(
            macroRatio: _controller.macroRatio,
            macroChangePercent: _controller.macroChangePercent,
            macroDataPercentage: _controller.macroDataPercentage,
          ),

        ],
      ),
    );
  }

  // --- WIDGET UNTUK FILTER ---
  Widget _buildFilterControls() {
    VoidCallback onTapAction;
    switch (_controller.selectedPeriod) {
      case StatisticsPeriod.daily:
        onTapAction = () => _controller.changeDailyDate(context);
        break;
      case StatisticsPeriod.weekly:
        onTapAction = () => _controller.changeWeek(context);
        break;
      case StatisticsPeriod.monthly:
        onTapAction = () => _controller.changeMonth(context);
        break;
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<StatisticsPeriod>(
            segments: const [
              ButtonSegment(
                value: StatisticsPeriod.daily,
                label: Text('Harian'),
                icon: Icon(Icons.calendar_view_day),
              ),
              ButtonSegment(
                value: StatisticsPeriod.weekly,
                label: Text('Mingguan'),
                icon: Icon(Icons.calendar_view_week),
              ),
              ButtonSegment(
                value: StatisticsPeriod.monthly,
                label: Text('Bulanan'),
                icon: Icon(Icons.calendar_month),
              ),
            ],
            selected: {_controller.selectedPeriod},
            onSelectionChanged: (Set<StatisticsPeriod> newSelection) {
              _controller.changePeriod(newSelection.first);
            },
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: Theme.of(context).primaryColor.withAlpha(50),
              selectedForegroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 50,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          child: Opacity(
            opacity: 1.0,
            child: InkWell(
              onTap: onTapAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _controller.selectedDateFormatted,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, size: 24, color: Colors.grey[700]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

// === WIDGET BUILDER UNTUK TAB DETAIL ===
  Widget _buildDetailTab() {
    if (_controller.selectedDetailCategory == null) {
      return ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: _controller.detailCategories.length,
        itemBuilder: (context, index) {
          final category = _controller.detailCategories[index];
          return DetailCategoryTile(
            title: category['title'],
            icon: category['icon'],
            onTap: () => _controller.onDetailCategoryTap(category['title']),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      );
    } else {
      Widget detailContent;
      switch (_controller.selectedDetailCategory) {
        case 'Kalori':
          detailContent = CalorieDetailContent(controller: _controller);
          break;
        case 'Makronutrien':
          detailContent = MacroDetailContent(controller: _controller);
          break;
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