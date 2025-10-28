import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart

// Widget to display the nutrition line chart and its legend
class NutritionChartSection extends StatelessWidget {
  const NutritionChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row (Title and Dropdown)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Nutrisi Makanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // TODO: Replace TextButton with DropdownButton for actual functionality
            TextButton(
              onPressed: () {
                // Logic to change period (Weekly, Monthly, etc.)
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text('Weekly', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold)),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF007BFF)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Line Chart Container
        SizedBox(
          height: 180, // Fixed height for the chart
          child: LineChart(
            LineChartData(
              // Chart configurations (Axis, Grid, Border)
              minX: 0, maxX: 6, minY: 0, maxY: 100, // X: Days (0-6), Y: Percentage (0-100)
              titlesData: _buildTitlesData(), // Use helper for titles
              gridData: _buildGridData(),     // Use helper for grid
              borderData: FlBorderData(show: false), // Hide chart border
              lineBarsData: _buildLineBarsData(), // Use helper for line data
              lineTouchData: const LineTouchData(enabled: false), // Disable touch interactions
            ),
          ),
        ),
        const SizedBox(height: 10), // Space between chart and legend
        // Legend below the chart
        _buildChartLegend(), // Use helper for legend
      ],
    );
  }

  // --- Chart Configuration Helpers ---

  // Helper to configure Axis Titles
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      // Bottom Axis (Days)
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1, // Show label for every day
          reservedSize: 25, // Space below chart
          getTitlesWidget: (value, meta) {
            const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            final index = value.toInt();
            // Highlight 'Thu' (index 4 in this 0-6 range, assuming Sunday is 0)
            final isToday = index == 4; // Adjust index if week start differs
            if (index >= 0 && index < days.length) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday ? const Color(0xFF007BFF) : Colors.grey, // Blue for today
                  ),
                ),
              );
            }
            return Container(); // Empty container for invalid values
          },
        ),
      ),
      // Left Axis (Percentage)
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20, // Show labels every 20%
          reservedSize: 35, // Space left of chart
          getTitlesWidget: (value, meta) {
            // Only show labels for 0, 20, 40, 60, 80, 100
            if (value % 20 == 0) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Text('${value.toInt()}%', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              );
            }
            return Container(); // Empty for other values
          },
        ),
      ),
      // Hide Top and Right Axis Titles
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  // Helper to configure Grid Lines
  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false, // Hide vertical grid lines
      horizontalInterval: 20, // Match left axis interval
      getDrawingHorizontalLine: (value) => FlLine(
        color: Colors.grey.withOpacity(0.2), // Lighter grid lines
        strokeWidth: 1,
        // dashArray: [4, 4] // Optional: Dashed lines
      ),
    );
  }

  // Helper to build the data for the four lines (Calories, Sugar, Fibre, Fats)
  List<LineChartBarData> _buildLineBarsData() {
    // Dummy data points (replace with actual data)
    const spotsCalories = [FlSpot(0, 70), FlSpot(1, 82), FlSpot(2, 60), FlSpot(3, 40), FlSpot(4, 30), FlSpot(5, 50), FlSpot(6, 60)];
    const spotsSugar = [FlSpot(0, 50), FlSpot(1, 45), FlSpot(2, 39), FlSpot(3, 30), FlSpot(4, 35), FlSpot(5, 40), FlSpot(6, 45)];
    const spotsFibre = [FlSpot(0, 60), FlSpot(1, 75), FlSpot(2, 88), FlSpot(3, 80), FlSpot(4, 70), FlSpot(5, 65), FlSpot(6, 70)];
    const spotsFats = [FlSpot(0, 40), FlSpot(1, 55), FlSpot(2, 45), FlSpot(3, 42), FlSpot(4, 50), FlSpot(5, 55), FlSpot(6, 60)];

    // Function to create a dot painter (highlighting specific points)
    FlDotCirclePainter Function(FlSpot spot, double percent, LineChartBarData barData, int index) _getDotPainter(Color color, int highlightedIndex) {
      return (FlSpot spot, double percent, LineChartBarData barData, int index) {
        return FlDotCirclePainter(
          radius: (index == highlightedIndex) ? 4.5 : 3, // Larger radius for highlighted dot
          color: color,
          strokeWidth: 0, // No border for dots
        );
      };
    }


    return [
      // Calories Line (Blue) - Highlight Mon (index 1)
      LineChartBarData(
        spots: spotsCalories, isCurved: true, color: const Color(0xFF007BFF), barWidth: 2.5,
        isStrokeCapRound: true, dotData: FlDotData(show: true, getDotPainter: _getDotPainter(const Color(0xFF007BFF), 1)),
        belowBarData: BarAreaData(show: false),
      ),
      // Sugar Line (Pink) - Highlight Tue (index 2)
      LineChartBarData(
        spots: spotsSugar, isCurved: true, color: const Color(0xFFFF4081), barWidth: 2.5,
        isStrokeCapRound: true, dotData: FlDotData(show: true, getDotPainter: _getDotPainter(const Color(0xFFFF4081), 2)),
        belowBarData: BarAreaData(show: false),
      ),
      // Fibre Line (Cyan) - Highlight Tue (index 2)
      LineChartBarData(
        spots: spotsFibre, isCurved: true, color: const Color(0xFF00BCD4), barWidth: 2.5,
        isStrokeCapRound: true, dotData: FlDotData(show: true, getDotPainter: _getDotPainter(const Color(0xFF00BCD4), 2)),
        belowBarData: BarAreaData(show: false),
      ),
      // Fats Line (Yellow/Orange) - Highlight Wed (index 3)
      LineChartBarData(
        spots: spotsFats, isCurved: true, color: const Color(0xFFFFC107), barWidth: 2.5,
        isStrokeCapRound: true, dotData: FlDotData(show: true, getDotPainter: _getDotPainter(const Color(0xFFFFC107), 3)),
        belowBarData: BarAreaData(show: false),
      ),
    ];
  }

  // Helper to build the legend items
  Widget _buildChartLegend() {
    // Dummy trend data (replace with actual calculations)
    return Wrap( // Use Wrap for responsiveness
      spacing: 15.0, // Horizontal space between items
      runSpacing: 8.0,   // Vertical space between lines
      children: [
        _buildTrendLabel('Calories', '82%↑', const Color(0xFF007BFF), true),
        _buildTrendLabel('Sugar', '39%↓', const Color(0xFFFF4081), false),
        _buildTrendLabel('Fibre', '88%↑', const Color(0xFF00BCD4), true),
        _buildTrendLabel('Fats', '42%↓', const Color(0xFFFFC107), false),
      ],
    );
  }

  // Helper for individual legend item
  Widget _buildTrendLabel(String label, String value, Color color, bool isUp) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Keep row items close together
      children: [
        // Optional: Add a colored dot indicator
        // Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        // const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])), // Darker grey
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
        Icon(
          isUp ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: color,
        ),
      ],
    );
  }
}