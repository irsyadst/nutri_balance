import 'package:flutter/material.dart';
// Hapus import SVG jika tidak digunakan lagi di sini
// import 'package:flutter_svg/flutter_svg.dart';
import '../../models/user_model.dart';
// Import layar tujuan navigasi
import 'home_screen.dart';
import 'profile_screen.dart';
import 'meal_package_screen.dart'; // Pastikan nama file sesuai
import 'statistics_screen.dart';
// Import widget bottom navigation bar yang baru
import '../widgets/main_app/custom_bottom_navigation_bar.dart';

class MainAppScreen extends StatefulWidget {
  final User user;
  const MainAppScreen({super.key, required this.user});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0; // State untuk index tab yang aktif

  late final List<Widget> _widgetOptions; // Daftar halaman/widget untuk tiap tab

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar halaman (pastikan urutan sesuai dengan item di bottom nav bar)
    _widgetOptions = <Widget>[
      HomeScreen(user: widget.user), // Index 0: Beranda
      const MealPackageScreen(),      // Index 1: Paket Makan (Ganti jika nama berbeda)
      const StatisticsScreen(),       // Index 2: Statistik
      ProfileScreen(initialUser: widget.user), // Index 3: Profil
    ];
  }

  // Fungsi callback saat item bottom navigation bar di-tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update index yang aktif
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan widget/halaman sesuai dengan _selectedIndex
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // Gunakan widget CustomBottomNavigationBar yang sudah dibuat
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex, // Berikan index saat ini
        onTap: _onItemTapped,       // Berikan fungsi callback saat di-tap
      ),
    );
  }

}