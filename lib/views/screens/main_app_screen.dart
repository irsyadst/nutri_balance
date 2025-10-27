import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SVG jika ikon Anda SVG
import '../../models/user_model.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
// --- 1. PASTIKAN SEMUA LAYAR DIIMPORT ---
import 'meal_package_screen.dart';
import 'statistics_screen.dart';

class MainAppScreen extends StatefulWidget {
  final User user;
  const MainAppScreen({super.key, required this.user});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0; // Mulai dari Beranda

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // --- 2. LENGKAPI DAFTAR HALAMAN SESUAI URUTAN NAVIGASI ---
    _widgetOptions = <Widget>[
      HomeScreen(user: widget.user), // 0: Beranda
      const MealPackageScreen(),      // 1: Paket Makan (Layar baru Anda)
      const StatisticsScreen(),       // 2: Statistik (Ganti dengan layar Anda jika sudah ada)
      ProfileScreen(user: widget.user), // 3: Profil
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi pembantu untuk membuat ikon
  Widget _buildIcon(IconData iconData, int index, Color activeColor, Color inactiveColor) {
    return Icon(
      iconData,
      color: _selectedIndex == index ? activeColor : inactiveColor,
      size: 28, // Sesuaikan ukuran
    );
  }

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF007BFF);
    const inactiveColor = Colors.grey;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: Container(

        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,


            backgroundColor: Colors.white,
            selectedItemColor: activeColor,
            unselectedItemColor: inactiveColor,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            type: BottomNavigationBarType.fixed,

            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.home_outlined, 0, activeColor, inactiveColor),
                activeIcon: _buildIcon(Icons.home, 0, activeColor, inactiveColor),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.calendar_month_outlined, 1, activeColor, inactiveColor),
                activeIcon: _buildIcon(Icons.calendar_month, 1, activeColor, inactiveColor),
                // Ganti label jika perlu
                label: 'Jadwal Makan',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.bar_chart_outlined, 2, activeColor, inactiveColor),
                activeIcon: _buildIcon(Icons.bar_chart, 2, activeColor, inactiveColor),
                label: 'Statistik',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.person_outline, 3, activeColor, inactiveColor),
                activeIcon: _buildIcon(Icons.person, 3, activeColor, inactiveColor),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}