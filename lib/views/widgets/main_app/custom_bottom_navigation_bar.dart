import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; // Callback saat item di-tap

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildIcon(IconData iconData, IconData activeIconData, int index, Color activeColor, Color inactiveColor) {
    return Icon(
      currentIndex == index ? activeIconData : iconData,
      color: currentIndex == index ? activeColor : inactiveColor,
      size: 28,
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    const inactiveColor = Colors.grey;

    return Container(
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
          onTap: onTap,
          currentIndex: currentIndex,

          backgroundColor: Colors.white,
          selectedItemColor: activeColor,
          unselectedItemColor: inactiveColor,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 0,

          items: <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home_outlined, Icons.home, 0, activeColor, inactiveColor),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.calendar_month_outlined, Icons.calendar_month, 1, activeColor, inactiveColor),
              label: 'Jadwal Makan',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.bar_chart_outlined, Icons.bar_chart, 2, activeColor, inactiveColor),
              label: 'Statistik',
            ),
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