import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'meal_package_screen.dart';
import 'statistics_screen.dart';
import '../widgets/main_app/custom_bottom_navigation_bar.dart';

class MainAppScreen extends StatefulWidget {
  final User user;
  const MainAppScreen({super.key, required this.user});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(initialUser: widget.user),
      MealPackageScreen(),
      const StatisticsScreen(),
      ProfileScreen(initialUser: widget.user),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

}