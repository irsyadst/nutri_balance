import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Hari Ini Section
            _buildTargetSection(),
            const SizedBox(height: 30),

            // Kemajuan Kegiatan Section
            _buildProgressSection(),
            const SizedBox(height: 30),

            // Aktivitas Terbaru Section
            _buildRecentActivitySection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // === WIDGET PEMBANGUN (BUILDERS) ===

  Widget _buildTargetSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3FF), // Latar belakang biru muda
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Hari Ini',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF007BFF), size: 28),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildTargetCard('8L', 'Asupan Air', Icons.local_drink, const Color(0xFF90CAF9))),
              const SizedBox(width: 15),
              Expanded(child: _buildTargetCard('2400', 'Langkah Kaki', Icons.directions_walk, const Color(0xFFFFF176))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard(String value, String label, IconData icon, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon dan Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    // Data dummy untuk Bar Chart
    final List<double> dailyProgress = [0.3, 0.6, 0.7, 0.5, 0.9, 0.2, 0.8]; // Nilai progress 0.0 - 1.0
    final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kemajuan Kegiatan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Text('Weekly', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.w600)),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF007BFF)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Bar Chart
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(dailyProgress.length, (index) {
            return _buildBar(days[index], dailyProgress[index]);
          }),
        ),
      ],
    );
  }

  Widget _buildBar(String day, double progress) {
    const double barWidth = 25;
    const double barMaxHeight = 150;

    // Warna: Abu-abu untuk latar belakang (full height), Biru untuk progress
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bar Stack
        SizedBox(
          height: barMaxHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background Bar (Light Gray)
              Container(
                width: barWidth,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Progress Bar (Blue)
              Container(
                width: barWidth,
                height: barMaxHeight * progress,
                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Day Label
        Text(day, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See more', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        
        // Daftar Aktivitas
        _buildActivityTile(
          'Minum 300ml Air',
          'Sekitar 3 menit yang lalu',
          const Color(0xFFE7F3FF), // Latar belakang ikon biru muda
          const Color(0xFF007BFF), // Warna utama ikon (placeholder)
        ),
        const SizedBox(height: 15),
        _buildActivityTile(
          'Makan Camilan (Fitbar)',
          'Sekitar 10 menit yang lalu',
          const Color(0xFFF9E7E7), // Latar belakang ikon merah muda muda
          const Color(0xFFC70039), // Warna utama ikon (placeholder)
        ),
      ],
    );
  }

  Widget _buildActivityTile(String title, String subtitle, Color avatarBgColor, Color avatarFgColor) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Placeholder Avatar (Menggunakan CircleAvatar dengan warna background)
          CircleAvatar(
            radius: 25,
            backgroundColor: avatarBgColor,
            child: Icon(
              title.contains('Minum') ? Icons.water_drop : Icons.fastfood,
              color: avatarFgColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          // Title & Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}