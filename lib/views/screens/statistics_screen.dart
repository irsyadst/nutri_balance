import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:intl/intl.dart'; // Import intl
import 'dart:math';


import '../widgets/statistics/calorie_detail_content.dart';
import '../widgets/statistics/weight_detail_content.dart';
import '../widgets/statistics/macro_detail_content.dart';
import '../widgets/statistics/water_detail_content.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Minggu Ini';
  String? _selectedDetailCategory;

  // --- Data Dummy ---
  final double currentWeight = 155;
  final double weightChangePercent = -2;
  final String weightPeriod = "30 Hari Terakhir";
  final int caloriesToday = 2000;
  final double calorieChangePercent = 5;
  final String macroRatio = "40/30/30";
  final double macroChangePercent = 10;

  final List<FlSpot> weightSpots = const [
    FlSpot(0, 157), FlSpot(1, 158), FlSpot(2, 156), FlSpot(3, 159),
    FlSpot(4, 157), FlSpot(5, 155), FlSpot(6, 156), FlSpot(7, 154),
    FlSpot(8, 156), FlSpot(9, 158), FlSpot(10, 155), FlSpot(11, 157),
  ];
  final Map<String, double> calorieData = const {
    'Sarapan': 500, 'Makan siang': 700, 'Makan malam': 600, 'Makanan ringan': 200,
  };
  final double maxCaloriePerMeal = 800;
  final Map<String, double> macroData = const {
    'Protein': 40, 'Karbohidrat': 35, 'Lemak': 25,
  };
  // HAPUS DATA DUMMY AKTIVITAS
  // final Map<String, String> activityData = const {
  //   'Tangga': '5.000', 'Jarak': '2,5 mil', 'Lamanya': '45 menit',
  // };
  // --- Akhir Data Dummy ---


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchStatisticsData();
    // Listener TabController
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _tabController.index == 0) {
        setState(() { _selectedDetailCategory = null; });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchStatisticsData() async {
    print("Fetching statistics for: $_selectedPeriod");
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: Panggil controller/API untuk ambil data
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedDetailCategory == null ? Colors.grey[50] : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            (_tabController.index != 0 || _selectedDetailCategory != null)
                ? Icons.arrow_back
                : null,
            color: Colors.black,
          ),
          onPressed: () {
            if (_tabController.index == 1 && _selectedDetailCategory != null) {
              setState(() { _selectedDetailCategory = null; });
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _selectedDetailCategory != null ? 'Detail $_selectedDetailCategory' : 'Statistik',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
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
            : null,
      ),
      body: TabBarView(
        controller: _tabController,
        physics: _selectedDetailCategory == null ? null : const NeverScrollableScrollPhysics(),
        children: [
          _buildSummaryTab(),
          _buildDetailTab(),
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB RINGKASAN ===
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Kemajuan Berat Badan'),
          const SizedBox(height: 15),
          _buildWeightProgressCard(),
          const SizedBox(height: 35),
          _buildSectionTitle('Asupan Kalori'),
          const SizedBox(height: 15),
          _buildCalorieIntakeCard(),
          const SizedBox(height: 35),
          _buildSectionTitle('Kerusakan Makronutrien'),
          const SizedBox(height: 15),
          _buildMacroBreakdownCard(),
          const SizedBox(height: 35), // Jarak bawah setelah Makro
        ],
      ),
    );
  }

  // === WIDGET BUILDER UNTUK TAB DETAIL ===
  Widget _buildDetailTab() {
    if (_selectedDetailCategory == null) {
      // --- HAPUS 'Aktivitas' DARI LIST INI ---
      final List<Map<String, dynamic>> detailCategories = [
        {'title': 'Kalori', 'icon': Icons.local_fire_department_outlined},
        {'title': 'Berat Badan', 'icon': Icons.monitor_weight_outlined},
        {'title': 'Makronutrien', 'icon': Icons.pie_chart_outline},
        {'title': 'Asupan Air', 'icon': Icons.water_drop_outlined},
      ];
      // --- AKHIR PENGHAPUSAN ---

      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 24.0),
        itemCount: detailCategories.length,
        itemBuilder: (context, index) {
          final category = detailCategories[index];
          return _buildDetailCategoryTile(
            title: category['title'],
            icon: category['icon'],
            onTap: () {
              setState(() { _selectedDetailCategory = category['title']; });
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 18),
      );
    } else {
      Widget detailContent;
      // --- HAPUS CASE 'Aktivitas' DARI SWITCH INI ---
      switch (_selectedDetailCategory) {
        case 'Kalori': detailContent = const CalorieDetailContent(); break;
        case 'Berat Badan': detailContent = const WeightDetailContent(); break;
        case 'Makronutrien': detailContent = const MacroDetailContent(); break;
      // case 'Aktivitas': detailContent = const ActivityDetailContent(); break; // <-- Hapus case ini
        case 'Asupan Air': detailContent = const WaterDetailContent(); break;
        default: detailContent = const Center(child: Text('Konten detail tidak ditemukan'));
      }
      // --- AKHIR PENGHAPUSAN ---
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: detailContent,
      );
    }
  }

  // Helper widget lainnya (TIDAK BERUBAH)
  Widget _buildDetailCategoryTile({ required String title, required IconData icon, required VoidCallback onTap,}) { /* ... kode sama ... */
    return InkWell( onTap: onTap, borderRadius: BorderRadius.circular(15), child: Container( padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [ BoxShadow( color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4), ) ], border: Border.all(color: Colors.grey.shade200, width: 1), ), child: Row( children: [
      Icon(icon, color: Theme.of(context).primaryColor, size: 26),
      const SizedBox(width: 15),
      Expanded( child: Text( title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), ),
      Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade400), ], ), ), );
  }
  Widget _buildSectionTitle(String title) { /* ... kode sama ... */
    return Text( title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
  }
  Widget _buildWeightProgressCard() { /* ... kode sama ... */
    final primaryColor = Theme.of(context).primaryColor;
    return Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Berat', style: TextStyle(fontSize: 16, color: Colors.grey)),
      Text('${currentWeight.round()} pon', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      Text( '$weightPeriod ${weightChangePercent > 0 ? '+' : ''}$weightChangePercent%', style: TextStyle( fontSize: 14, color: weightChangePercent < 0 ? Colors.green : Colors.red, fontWeight: FontWeight.w500, ), ),
      const SizedBox(height: 20),
      SizedBox( height: 150, child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, reservedSize: 25, interval: 2,
                getTitlesWidget: (value, meta) {
                  const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
                  final index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    return Padding( padding: const EdgeInsets.only(top: 8.0, right: 4.0), child: Text(labels[index], style: TextStyle(color: Colors.grey.shade600, fontSize: 10)), );
                  } return const Text('');
                },),),),
          borderData: FlBorderData(show: false),
          lineBarsData: [ LineChartBarData( spots: weightSpots, isCurved: true, color: primaryColor, barWidth: 3, isStrokeCapRound: true, dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: false), ), ],),
      ), ), ], );
  }
  Widget _buildCalorieIntakeCard() { /* ... kode sama ... */
    return Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Kalori', style: TextStyle(fontSize: 16, color: Colors.grey)),
      Text(NumberFormat.decimalPattern('id_ID').format(caloriesToday), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      Text( 'Hari ini ${calorieChangePercent > 0 ? '+' : ''}$calorieChangePercent%', style: TextStyle( fontSize: 14, color: calorieChangePercent > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.w500, ), ),
      const SizedBox(height: 20),
      SizedBox( height: 125, child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: calorieData.entries.map((entry) {
        return Expanded( child: _buildCalorieBar( label: entry.key, value: entry.value, maxValue: maxCaloriePerMeal, ), );
      }).toList(), ), ), ], );
  }
  Widget _buildCalorieBar({required String label, required double value, required double maxValue}) { /* ... kode sama ... */
    final double progress = max(0.0, min(1.0, value / maxValue));
    final primaryColor = Theme.of(context).primaryColor;
    return Padding( padding: const EdgeInsets.symmetric(horizontal: 4.0), child: Column( mainAxisAlignment: MainAxisAlignment.end, children: [
      Container( width: 50, height: 80, decoration: BoxDecoration( color: Colors.grey.shade200, borderRadius: const BorderRadius.all(Radius.circular(8)), ), alignment: Alignment.bottomCenter, child: Container( height: 80 * progress, decoration: BoxDecoration( color: primaryColor, borderRadius: const BorderRadius.all(Radius.circular(8)), ), ), ),
      const SizedBox(height: 8),
      Text( label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis, ), ], ), );
  }
  Widget _buildMacroBreakdownCard() { /* ... kode sama ... */
    return Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Makro', style: TextStyle(fontSize: 16, color: Colors.grey)),
      Text(macroRatio, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      Text( 'Hari ini ${macroChangePercent > 0 ? '+' : ''}$macroChangePercent%', style: TextStyle( fontSize: 14, color: macroChangePercent > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.w500, ), ),
      const SizedBox(height: 20),
      ...macroData.entries.map((entry) {
        return _buildMacroBar( label: entry.key, percentage: entry.value, );
      }).toList(), ], );
  }
  Widget _buildMacroBar({required String label, required double percentage}) { /* ... kode sama ... */
    Color color; if (label == 'Protein') { color = Theme.of(context).primaryColor; } else if (label == 'Karbohidrat') { color = Colors.green.shade400; } else { color = Colors.amber.shade400; }
    return Padding( padding: const EdgeInsets.only(bottom: 12.0), child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
      const SizedBox(height: 5),
      ClipRRect( borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator( value: percentage / 100, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 12, ), ), ], ), );
  }

}