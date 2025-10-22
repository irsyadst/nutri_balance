import 'package:flutter/material.dart';
// Asumsikan path model dan screens Anda sudah benar
import '../../models/user_model.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'meal_planner_screen.dart'; // <<< WAJIB DITAMBAHKAN

// Halaman Wrapper Aplikasi Utama dengan Bottom Navigation
class MainAppScreen extends StatefulWidget {
  // Menambahkan parameter untuk menerima data pengguna
  final User user;
  const MainAppScreen({super.key, required this.user});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  // Daftar halaman sekarang dibuat di sini agar bisa mengakses `widget.user`
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar halaman hanya dengan 3 item: Home, Calories, Profile
    _widgetOptions = <Widget>[
      HomeScreen(user: widget.user), // 0: Home
      const MealPlannerScreen(), // 1: Calories (Ganti Placeholder dengan MealPlannerScreen)
      ProfileScreen(user: widget.user), // 2: Profile
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi pembantu untuk membuat ikon dari asset dan mengelola warna
  Widget _buildAssetIcon(String path, {Color? color}) {
    return Image.asset(
      path,
      width: 28, // Ukuran ikon sesuai keinginan
      height: 28,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan warna aktif (biru) dan tidak aktif (abu-abu)
    const activeColor = Color(0xFF007BFF); 
    const inactiveColor = Colors.grey;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      
      // Bagian Bottom Navigation Bar dengan styling melengkung
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000), // Shadow ringan
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
            
            // Styling
            backgroundColor: Colors.white,
            selectedItemColor: activeColor,
            unselectedItemColor: inactiveColor,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            type: BottomNavigationBarType.fixed,

            items: <BottomNavigationBarItem>[
              // 1. Home
              BottomNavigationBarItem(
                icon: _buildAssetIcon('assets/images/home-navbar.png', 
                    color: _selectedIndex == 0 ? activeColor : inactiveColor),
                label: 'Home',
              ),
              // 2. Calories
              BottomNavigationBarItem(
                icon: _buildAssetIcon('assets/images/calories-navbar.png',
                    color: _selectedIndex == 1 ? activeColor : inactiveColor),
                label: 'Calories',
              ),
              // 3. Profile
              BottomNavigationBarItem(
                icon: _buildAssetIcon('assets/images/profile-navbar.png',
                    color: _selectedIndex == 2 ? activeColor : inactiveColor),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}