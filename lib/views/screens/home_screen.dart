// lib/views/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'dart:math'; 
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/user_model.dart';
import 'activity_tracker_screen.dart'; 
import 'notification_screen.dart';

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

                  // Tombol Target Hari Ini (Trigger ke Activity Tracker)
                  _buildTargetButton(context),
                  const SizedBox(height: 20),

                  // Grid Kartu Aktivitas Bawah
                  _buildActivityGrid(),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // === WIDGET PEMBANGUN (BUILDERS) ===

  Widget _buildHeader(BuildContext context, String userName) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Avatar Profil menggunakan Image.asset
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Tambahkan border tipis agar mirip desain
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
                // Teks Welcome
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
                // Icon Search
                IconButton(
                  icon: const Icon(Icons.search, size: 30, color: Colors.black54),
                  onPressed: () {},
                ),
                // Icon Notifikasi
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
                          color: const Color(0xFFFFCC00), // Warna oranye/kuning
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
          // Calorie Progress Arc
          _buildCalorieProgressArc(calorieProgress, caloriesEaten.round(), caloriesGoal.round()),
          const SizedBox(height: 30),
          
          // Macro Details
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
    return Stack(
      alignment: Alignment.center,
      children: [
        // Custom Paint untuk Arc/Busur Progress
        SizedBox(
          width: 250,
          height: 125,
          child: CustomPaint(
            painter: ArcProgressPainter(progress: progress),
          ),
        ),
        // Teks di tengah
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
    Color color;

    if (title == 'Protein') {
      color = const Color(0xFFC70039); 
    } else if (title == 'Fats') {
      color = const Color(0xFFFFC300); 
    } else { // Carbs
      color = const Color(0xFF4CAF50);
    }

    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text(
          '$eaten/${goal}g',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        // Progress Bar Makro
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

  Widget _buildActivityGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildWaterCard()),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            children: [
              _buildSleepCard(),
              const SizedBox(height: 15),
              _buildFastingCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaterCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFE7F3FF), 
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Asupan Air', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('4 Liter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF007BFF))),
            Text('Real time update', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Water Level Bar
                Container(
                  width: 12,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 90, // Progress 75%
                    decoration: BoxDecoration(
                      color: const Color(0xFF007BFF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Timeline Air
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WaterTimelineItem(time: '6am - 8am', amount: '600ml', isCompleted: true),
                      _WaterTimelineItem(time: '9am - 11am', amount: '500ml', isCompleted: true),
                      _WaterTimelineItem(time: '11am - 2pm', amount: '1000ml', isCompleted: true),
                      _WaterTimelineItem(time: '2pm - 4pm', amount: '700ml', isCompleted: false), 
                      _WaterTimelineItem(time: '4pm - now', amount: '900ml', isCompleted: false),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFF0F0F0), 
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tidur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('8 jam 20 menit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF007BFF))),
            const SizedBox(height: 10),
            // Grafik Tidur (Gelombang SVG)
            SvgPicture.string(
              '''<svg viewBox="0 0 160 30" xmlns="http://www.w3.org/2000/svg">
                <path d="M0 15 C 20 5, 40 25, 60 15 S 100 5, 120 15 S 140 25, 160 15" stroke="#007BFF" fill="none" stroke-width="2"/>
              </svg>''',
              width: double.infinity,
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFastingCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFF9E7E7), 
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Puasa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('14 jam 20 menit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFC70039))),
            const SizedBox(height: 10),
            // Lingkaran puasa
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: 0.8, // Contoh progress
                      strokeWidth: 8,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC70039)),
                    ),
                  ),
                  Text(
                    '230Kcal\nhilang',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter untuk busur progress kalori (TIDAK BERUBAH)
class ArcProgressPainter extends CustomPainter {
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

// Item Timeline Asupan Air (TIDAK BERUBAH)
class _WaterTimelineItem extends StatelessWidget {
  final String time;
  final String amount;
  final bool isCompleted;

  const _WaterTimelineItem({required this.time, required this.amount, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5.0, right: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? const Color(0xFF007BFF) : Colors.grey[400],
            ),
          ),
          // Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time, 
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              Text(
                amount, 
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? Colors.black87 : Colors.grey, 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}