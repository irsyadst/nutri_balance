import 'package:flutter/material.dart';
import 'dart:math'; // For min function

// Main Card Widget
class CalorieMacroCard extends StatelessWidget {
  final double caloriesEaten;
  final double caloriesGoal;
  final int proteinEaten;
  final int proteinGoal;
  final int fatsEaten;
  final int fatsGoal;
  final int carbsEaten;
  final int carbsGoal;

  const CalorieMacroCard({
    super.key,
    required this.caloriesEaten,
    required this.caloriesGoal,
    required this.proteinEaten,
    required this.proteinGoal,
    required this.fatsEaten,
    required this.fatsGoal,
    required this.carbsEaten,
    required this.carbsGoal,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress safely, avoiding division by zero
    final double calorieProgress = (caloriesGoal > 0) ? min(1.0, caloriesEaten / caloriesGoal) : 0.0;
    final double proteinProgress = (proteinGoal > 0) ? min(1.0, proteinEaten / proteinGoal) : 0.0;
    final double fatProgress = (fatsGoal > 0) ? min(1.0, fatsEaten / fatsGoal) : 0.0;
    final double carbProgress = (carbsGoal > 0) ? min(1.0, carbsEaten / carbsGoal) : 0.0;

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
          // Calorie Arc Progress
          _CalorieProgressArc( // Use the internal widget
            progress: calorieProgress,
            eaten: caloriesEaten.round(),
            goal: caloriesGoal.round(),
          ),
          const SizedBox(height: 30),
          // Macro Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroItem( // Use the internal widget
                title: 'Protein',
                eaten: proteinEaten,
                goal: proteinGoal,
                progress: proteinProgress,
                color: const Color(0xFFC70039), // Red
              ),
              _MacroItem(
                title: 'Fats',
                eaten: fatsEaten,
                goal: fatsGoal,
                progress: fatProgress,
                color: const Color(0xFFFFC300), // Yellow
              ),
              _MacroItem(
                title: 'Carbs',
                eaten: carbsEaten,
                goal: carbsGoal,
                progress: carbProgress,
                color: const Color(0xFF4CAF50), // Green
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Internal Widgets used only by CalorieMacroCard ---

// Widget for the Calorie Progress Arc
class _CalorieProgressArc extends StatelessWidget {
  final double progress;
  final int eaten;
  final int goal;

  const _CalorieProgressArc({
    required this.progress,
    required this.eaten,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250, // Consider making width dynamic if needed
          height: 125, // Half the width for a semi-circle
          child: CustomPaint(
            painter: _ArcProgressPainter(progress: progress), // Use the internal painter
          ),
        ),
        Positioned(
          bottom: 0, // Position text at the bottom center of the arc space
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${eaten.toString()} Kcal',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Text(
                'of ${goal > 0 ? goal.toString() : 'N/A'} Kcal', // Handle goal being zero
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget for a single Macro Item (Protein, Fat, Carb)
class _MacroItem extends StatelessWidget {
  final String title;
  final int eaten;
  final int goal;
  final double progress;
  final Color color;

  const _MacroItem({
    required this.title,
    required this.eaten,
    required this.goal,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text(
          '$eaten/${goal > 0 ? goal : '-'}g', // Display '-' if goal is 0
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            width: 75, // Fixed width for the progress bar
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
}


// --- Custom Painter (Internal to this file) ---
class _ArcProgressPainter extends CustomPainter {
  final double progress;
  _ArcProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 15.0;
    // Adjust rect to ensure arc is centered and fully visible
    final Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height), // Center based on bottom-middle
      width: size.width - strokeWidth,
      height: (size.width - strokeWidth) , // Height is double the radius (width/2)
    );

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Define gradient colors for the foreground arc
    const activeColor1 = Color(0xFF007BFF);
    const activeColor2 = Color(0xFF82B0F2); // Lighter blue

    final Paint foregroundPaint = Paint()
      ..shader = const LinearGradient( // Apply gradient
        colors: [activeColor1, activeColor2],
        begin: Alignment.centerLeft, // Gradient direction
        end: Alignment.centerRight,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round // Rounded ends
      ..strokeWidth = strokeWidth;

    const double startAngle = pi; // Start angle at 180 degrees (left side)
    const double sweepAngle = pi; // Sweep angle of 180 degrees (to the right side)

    // Draw background arc
    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);
    // Draw foreground arc based on progress
    canvas.drawArc(rect, startAngle, sweepAngle * progress.clamp(0.0, 1.0), false, foregroundPaint); // Clamp progress

    // Draw the circular marker at the end of the progress arc
    if (progress > 0) {
      final double angle = startAngle + sweepAngle * progress.clamp(0.0, 1.0);
      final double radius = rect.width / 2; // Radius of the arc
      final Offset center = Offset(size.width / 2, size.height); // Center of the arc base

      // Calculate marker position on the arc
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      // Determine marker color based on gradient and progress
      final gradientColor = Color.lerp(activeColor1, activeColor2, progress.clamp(0.0, 1.0)) ?? activeColor1;

      // Paint for the white inner circle of the marker
      final Paint markerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      // Paint for the colored border of the marker
      final Paint markerBorderPaint = Paint()
        ..color = gradientColor
        ..style = PaintingStyle.fill;

      // Draw the border circle first (slightly larger)
      canvas.drawCircle(Offset(x, y), strokeWidth / 2 + 2, markerBorderPaint);
      // Draw the inner white circle
      canvas.drawCircle(Offset(x, y), strokeWidth / 2, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArcProgressPainter oldDelegate) {
    return oldDelegate.progress != progress; // Repaint only if progress changes
  }
}