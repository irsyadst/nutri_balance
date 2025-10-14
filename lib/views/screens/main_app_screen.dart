import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

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
    // Inisialisasi daftar halaman dengan data pengguna yang diterima
    _widgetOptions = <Widget>[
      HomeScreen(user: widget.user), // Meneruskan user ke HomeScreen
      const Center(child: Text('Halaman Meal Planner')), // Placeholder
      const Center(child: Text('Halaman Notifikasi')), // Placeholder
      ProfileScreen(user: widget.user), // Meneruskan user ke ProfileScreen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF82B0F2),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

