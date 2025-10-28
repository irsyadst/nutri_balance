import 'package:flutter/material.dart';

class AddToMealButton extends StatelessWidget {
  final String mealName; // Misal: "Sarapan", "Makan Siang"
  final VoidCallback onPressed;

  const AddToMealButton({
    super.key,
    required this.mealName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container untuk styling (shadow, padding)
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Shadow lebih halus
            blurRadius: 15,
            offset: const Offset(0,-5), // Shadow ke atas
          )
        ],
        // Optional: tambahkan border radius atas jika diinginkan
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor, // Warna primer tema
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Radius sesuai desain lain
            elevation: 2, // Sedikit elevasi
          ),
          child: Text(
            'Tambahkan ke $mealName', // Teks dinamis
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}