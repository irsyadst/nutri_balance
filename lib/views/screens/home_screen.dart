import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/user_model.dart';
import 'activity_tracker_screen.dart';
import 'notification_screen.dart';
import 'add_food_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  // Contoh data statis untuk tampilan
  final double caloriesEaten = 1721;
  final double caloriesGoal = 2213;
  final int proteinEaten = 78;
  final int proteinGoal = 90;
  final int fatsEaten = 45;
  final int fatsGoal = 70;
  final int carbsEaten = 95;
  final int carbsGoal = 110;

  // --- Data Dummy untuk Target Makan ---
  final Map<String, Map<String, dynamic>> mealTargets = const {
    'Sarapan': {'icon': Icons.wb_sunny_outlined, 'consumed': 500, 'target': 600},
    'Makan siang': {'icon': Icons.restaurant_menu_outlined, 'consumed': 400, 'target': 700},
    'Makan malam': {'icon': Icons.nights_stay_outlined, 'consumed': 0, 'target': 600},
    'Makanan ringan': {'icon': Icons.bakery_dining_outlined, 'consumed': 400, 'target': 313}, // Target sisa dari total
  };
  final Map<String, Map<String, dynamic>> otherTargets = const {
    'Air': {'icon': Icons.water_drop_outlined, 'consumed': 2, 'target': 3, 'unit': 'L'},
    'Aktivitas': {'icon': Icons.fitness_center_outlined, 'consumed': 600, 'target': 900, 'unit': 'kkal'},
  };
  // --- Akhir Data Dummy ---


  @override
  Widget build(BuildContext context) {
    final userName = user.name.isNotEmpty ? user.name : 'Pengguna';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar/Header
            _buildHeader(context, userName),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Progress Kalori dan Makro
                  _buildCalorieAndMacroCard(
                    caloriesEaten: caloriesEaten,
                    caloriesGoal: caloriesGoal,
                    proteinEaten: proteinEaten,
                    proteinGoal: proteinGoal,
                    fatsEaten: fatsEaten,
                    fatsGoal: fatsGoal,
                    carbsEaten: carbsEaten,
                    carbsGoal: carbsGoal,
                  ),
                  const SizedBox(height: 20),

                  _buildTargetButton(context),
                  const SizedBox(height: 10),

                  _buildMealTargetGrid(),
                  const SizedBox(height: 10),

                  _buildAddFoodButton(context),
                ],
              ),
            ),
            const SizedBox(height: 40), // Padding bawah
          ],
        ),
      ),
    );
  }

  // === WIDGET PEMBANGUN (BUILDERS) ===

  Widget _buildHeader(BuildContext context, String userName) {
    // ... (Kode _buildHeader tetap sama) ...
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(
                      userName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, size: 30, color: Colors.black54),
                  onPressed: () {},
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications, size: 30, color: Colors.black54),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFCC00),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieAndMacroCard({
    required double caloriesEaten,
    required double caloriesGoal,
    required int proteinEaten,
    required int proteinGoal,
    required int fatsEaten,
    required int fatsGoal,
    required int carbsEaten,
    required int carbsGoal,
  }) {
    // ... (Kode _buildCalorieAndMacroCard tetap sama) ...
    final double calorieProgress = min(1.0, caloriesEaten / caloriesGoal);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalorieProgressArc(calorieProgress, caloriesEaten.round(), caloriesGoal.round()),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroItem('Protein', proteinEaten, proteinGoal, min(1.0, proteinEaten / proteinGoal)),
              _buildMacroItem('Fats', fatsEaten, fatsGoal, min(1.0, fatsEaten / fatsGoal)),
              _buildMacroItem('Carbs', carbsEaten, carbsGoal, min(1.0, carbsEaten / carbsGoal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieProgressArc(double progress, int eaten, int goal) {
    // ... (Kode _buildCalorieProgressArc tetap sama) ...
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 125,
          child: CustomPaint(
            painter: ArcProgressPainter(progress: progress),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${eaten.toString()} Kcal',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'of ${goal.toString()} Kcal',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroItem(String title, int eaten, int goal, double progress) {
    // ... (Kode _buildMacroItem tetap sama) ...
    Color color;
    if (title == 'Protein') color = const Color(0xFFC70039);
    else if (title == 'Fats') color = const Color(0xFFFFC300);
    else color = const Color(0xFF4CAF50); // Carbs

    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text(
          '$eaten/${goal}g',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            width: 75,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTargetButton(BuildContext context) {
    // ... (Kode _buildTargetButton tetap sama) ...
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Target Hari ini',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityTrackerScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 0,
            ),
            child: const Text('Check', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- BUAT FUNGSI BARU _buildMealTargetGrid() ---
  Widget _buildMealTargetGrid() {
    // Gabungkan kedua map target
    final allTargets = {...mealTargets, ...otherTargets};

    return GridView.builder(
      shrinkWrap: true, // Agar GridView tidak mengambil tinggi tak terbatas
      physics: const NeverScrollableScrollPhysics(), // Agar tidak bisa di-scroll terpisah
      itemCount: allTargets.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom
        crossAxisSpacing: 15, // Jarak antar kolom
        mainAxisSpacing: 15, // Jarak antar baris
        childAspectRatio: 1.8, // Rasio lebar/tinggi kartu (sesuaikan agar pas)
      ),
      itemBuilder: (context, index) {
        final title = allTargets.keys.elementAt(index);
        final data = allTargets.values.elementAt(index);
        return _buildMealTargetCard(
          title: title,
          icon: data['icon'],
          consumed: data['consumed'].toDouble(), // Pastikan double
          target: data['target'].toDouble(),     // Pastikan double
          unit: data['unit'] ?? 'kkal', // Default unit kkal jika tidak ada
        );
      },
    );
  }

  // --- BUAT WIDGET BARU _buildMealTargetCard() ---
  Widget _buildMealTargetCard({
    required String title,
    required IconData icon,
    required double consumed,
    required double target,
    required String unit,
  }) {
    final double progress = target > 0 ? min(1.0, consumed / target) : 0.0;
    // Tentukan warna progress bar, misal biru
    const progressColor = Color(0xFF007BFF);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
          const Spacer(), // Dorong ke bawah
          Text(
            // Format text berbeda untuk Air vs Kalori
            unit == 'L'
                ? '${consumed.toStringAsFixed(1)}/$target${unit}' // 1 angka desimal untuk Liter
                : '${consumed.round()}/${target.round()} $unit', // Bulatkan untuk kkal
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6, // Tinggi progress bar
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddFoodButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddFoodScreen()),
        );
      },
      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
      label: const Text(
        'Tambah Makanan',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007BFF),
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2,
      ),
    );
  }
}

// Custom Painter untuk busur progress kalori (TIDAK BERUBAH)
class ArcProgressPainter extends CustomPainter {
  // ... (Kode ArcProgressPainter tetap sama) ...
  final double progress;
  ArcProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 15.0;
    final Rect rect = Rect.fromLTRB(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth / 2, size.height * 2);

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    const activeColor1 = Color(0xFF007BFF);
    const activeColor2 = Color(0xFF82B0F2);

    final Paint foregroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [activeColor1, activeColor2],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    const double startAngle = pi;
    const double sweepAngle = pi;

    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);
    canvas.drawArc(rect, startAngle, sweepAngle * progress, false, foregroundPaint);

    if (progress > 0) {
      final double angle = startAngle + sweepAngle * progress;
      final double radius = rect.width / 2;
      final Offset center = Offset(size.width / 2, size.height);

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      final gradientColor = Color.lerp(activeColor1, activeColor2, progress) ?? activeColor1;

      final Paint markerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      final Paint markerBorderPaint = Paint()
        ..color = gradientColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), strokeWidth / 2 + 2, markerBorderPaint);
      canvas.drawCircle(Offset(x, y), strokeWidth / 2, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ArcProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
