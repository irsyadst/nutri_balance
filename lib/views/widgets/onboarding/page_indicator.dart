import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final Color activeColor;
  final Color inactiveColor;
  final double dotWidth;
  final double activeDotWidth;
  final double dotHeight;
  final double spacing;

  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.activeColor,
    this.inactiveColor = Colors.grey,
    this.dotWidth = 8.0,
    this.activeDotWidth = 24.0,
    this.dotHeight = 8.0,
    this.spacing = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) => _buildDot(index)),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: dotHeight,
      width: isActive ? activeDotWidth : dotWidth,
      margin: EdgeInsets.only(right: spacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dotHeight / 2),
        color: isActive ? activeColor : inactiveColor.withOpacity(0.5),
      ),
    );
  }
}