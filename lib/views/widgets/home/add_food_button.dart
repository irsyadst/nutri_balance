import 'package:flutter/material.dart';
import '../../screens/add_food_screen.dart'; // For navigation

class AddFoodButton extends StatelessWidget {
  const AddFoodButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Navigate to Add Food Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddFoodScreen()),
        );
      },
      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
      label: const Text(
        'Tambah Makanan',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007BFF), // Button color
        minimumSize: const Size(double.infinity, 55), // Full width, fixed height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2, // Slight shadow
      ),
    );
  }
}