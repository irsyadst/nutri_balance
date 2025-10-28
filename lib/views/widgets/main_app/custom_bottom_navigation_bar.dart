import 'package:flutter/material.dart';

// Widget khusus untuk BottomNavigationBar
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; // Callback saat item di-tap

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Helper untuk membuat ikon (dengan state aktif/tidak aktif)
  Widget _buildIcon(IconData iconData, IconData activeIconData, int index, Color activeColor, Color inactiveColor) {
    return Icon(
      currentIndex == index ? activeIconData : iconData, // Pilih ikon berdasarkan state
      color: currentIndex == index ? activeColor : inactiveColor,
      size: 28, // Sesuaikan ukuran ikon
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definisikan warna di sini agar mudah diubah
    final activeColor = Theme.of(context).primaryColor; // Ambil dari tema
    const inactiveColor = Colors.grey;

    return Container(
      // Dekorasi shadow dan border radius atas
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), // Warna shadow dengan opacity
            blurRadius: 10,
            offset: Offset(0, -5), // Shadow ke atas
          ),
        ],
      ),
      // ClipRRect untuk menerapkan border radius ke child (BottomNavigationBar)
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          onTap: onTap, // Gunakan callback dari parameter
          currentIndex: currentIndex, // Gunakan index saat ini dari parameter

          // Styling lainnya
          backgroundColor: Colors.white,
          selectedItemColor: activeColor,
          unselectedItemColor: inactiveColor,
          showUnselectedLabels: true, // Tampilkan label meskipun tidak aktif
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed, // Agar semua item terlihat
          elevation: 0, // Hapus elevasi default karena sudah ada shadow di container

          items: <BottomNavigationBarItem>[
            // Item Beranda
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home_outlined, Icons.home, 0, activeColor, inactiveColor),
              label: 'Beranda',
            ),
            // Item Jadwal Makan
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.calendar_month_outlined, Icons.calendar_month, 1, activeColor, inactiveColor),
              label: 'Jadwal Makan',
            ),
            // Item Statistik
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.bar_chart_outlined, Icons.bar_chart, 2, activeColor, inactiveColor),
              label: 'Statistik',
            ),
            // Item Profil
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person_outline, Icons.person, 3, activeColor, inactiveColor),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}