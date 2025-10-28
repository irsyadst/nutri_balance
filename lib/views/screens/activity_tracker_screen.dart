import 'package:flutter/material.dart';
// Import widget yang baru dibuat
import '../widgets/activity_tracker/target_section.dart';
import '../widgets/activity_tracker/progress_section.dart';
import '../widgets/activity_tracker/recent_activity_section.dart';

class ActivityTrackerScreen extends StatelessWidget {
  const ActivityTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Activity Tracker', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.more_horiz, color: Colors.black87), // Icon titik tiga
          ),
        ],
      ),
      body: const SingleChildScrollView( // Gunakan const jika child-nya const
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), // Padding bisa di sini
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gunakan widget yang sudah dipisah
            TargetSection(),
            SizedBox(height: 30),

            ProgressSection(),
            SizedBox(height: 30),

            RecentActivitySection(),
            SizedBox(height: 30), // Padding bawah tambahan jika perlu
          ],
        ),
      ),
    );
  }

}