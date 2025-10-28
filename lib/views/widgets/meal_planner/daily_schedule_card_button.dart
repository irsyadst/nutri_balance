import 'package:flutter/material.dart';

// Card that acts like a button for Daily Schedule
class DailyScheduleCardButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DailyScheduleCardButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer decoration for background and rounded corners
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3FF), // Light blue background
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material( // Material for InkWell ripple effect
        color: Colors.transparent,
        child: InkWell( // Make the whole card tappable
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15), // Match outer radius
          child: Padding( // Inner padding for content
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jadwal Makan Harian',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87), // Slightly smaller font
                ),
                // Simple "Check" button appearance
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007BFF), // Blue button background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Check',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}