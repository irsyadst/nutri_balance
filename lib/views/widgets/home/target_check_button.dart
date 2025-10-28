import 'package:flutter/material.dart';
import '../../screens/activity_tracker_screen.dart'; // For navigation

class TargetCheckButton extends StatelessWidget {
  const TargetCheckButton({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Navigate to Activity Tracker Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActivityTrackerScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF), // Button color
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 0, // No shadow
            ),
            child: const Text('Check', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}