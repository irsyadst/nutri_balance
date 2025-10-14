import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../widgets/macro_info.dart';
import '../widgets/target_card.dart';

// Halaman Home / Dashboard
class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  // Data dummy (nantinya akan diambil dari controller)
  final int consumedKcal = 1721;
  final int totalKcal = 2213;
  final double protein = 78;
  final double totalProtein = 90;
  final double fats = 45;
  final double totalFats = 70;
  final double carbs = 95;
  final double totalCarbs = 110;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome', style: TextStyle(color: Colors.grey, fontSize: 14)),
            // Menggunakan nama pengguna dari objek User
            Text(user.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [Padding(padding: const EdgeInsets.only(right: 16.0), child: CircleAvatar(backgroundColor: Colors.grey[200], child: const Icon(Icons.person, color: Colors.grey)))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalorieCard(), const SizedBox(height: 25),
            const Text('Target Hari ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15),
            const TargetCard(icon: Icons.water_drop_outlined, title: 'Asupan Air', value: '4 Liter', color: Color(0xFF82B0F2)),
            const SizedBox(height: 15),
            const TargetCard(icon: Icons.king_bed_outlined, title: 'Tidur', value: '8jam 20menit', color: Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF82B0F2).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          SizedBox(
            width: 120, height: 120,
            child: Stack(fit: StackFit.expand, children: [
              CircularProgressIndicator(
                value: consumedKcal / totalKcal, strokeWidth: 10,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF82B0F2)),
              ),
              Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('$consumedKcal', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                const Text('Kcal', style: TextStyle(color: Colors.grey)),
              ]))
            ]),
          ),
          const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MacroInfo(title: 'Protein', value: protein, total: totalProtein, color: Colors.red),
            const SizedBox(height: 15),
            MacroInfo(title: 'Fats', value: fats, total: totalFats, color: Colors.orange),
            const SizedBox(height: 15),
            MacroInfo(title: 'Carbs', value: carbs, total: totalCarbs, color: Colors.blueAccent),
          ])),
        ],
      ),
    );
  }
}