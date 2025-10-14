import 'package:flutter/material.dart';
import '../../models/user_model.dart';

// Halaman Profile
class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Menggunakan data profil jika ada, jika tidak gunakan data default
    final profile = user.profile;
    final height = profile?.height.toInt() ?? 'N/A';
    final weight = profile?.currentWeight.toInt() ?? 'N/A';
    final age = profile?.age ?? 'N/A';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(children: [
              const CircleAvatar(radius: 40, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 40, color: Colors.white)),
              const SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('$height cm | $weight kg | $age yo', style: const TextStyle(color: Colors.grey))
              ]),
              const Spacer(),
              SizedBox(height: 35, child: OutlinedButton(onPressed: (){}, child: const Text('Edit'),
                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF82B0F2), side: const BorderSide(color: Color(0xFF82B0F2)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))))),
            ]),
            const SizedBox(height: 30),
            // ... (Sisa kode menu tidak berubah)
          ],
        ),
      ),
    );
  }
}
