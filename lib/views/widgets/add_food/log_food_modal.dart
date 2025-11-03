import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_balance/models/meal_models.dart';

class LogFoodModal extends StatefulWidget {
  final Food food;
  final double initialQuantity;
  final String initialMealType;
  final Function(double quantity, String mealType) onLog; // Callback

  const LogFoodModal({
    super.key,
    required this.food,
    this.initialQuantity = 1.0,
    this.initialMealType = 'Sarapan',
    required this.onLog,
  });

  @override
  State<LogFoodModal> createState() => _LogFoodModalState();
}

class _LogFoodModalState extends State<LogFoodModal> {
  late TextEditingController _quantityController;
  late String _selectedMealType;
  final List<String> _mealTypes = ['Sarapan', 'Makan Siang', 'Makan Malam', 'Snack'];

  @override
  void initState() {
    super.initState();
    _selectedMealType = widget.initialMealType;
    _quantityController = TextEditingController(
      text: widget.initialQuantity.toStringAsFixed(1),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  // Fungsi untuk mendapatkan meal type berdasarkan waktu
  String _getMealTypeFromTime() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 10) return 'Sarapan';
    if (hour >= 10 && hour < 14) return 'Makan Siang';
    if (hour >= 14 && hour < 18) return 'Snack';
    if (hour >= 18 && hour < 22) return 'Makan Malam';
    return 'Snack'; // Default
  }

  @override
  Widget build(BuildContext context) {
    // Hitung nutrisi berdasarkan kuantitas
    final quantity = double.tryParse(_quantityController.text) ?? widget.initialQuantity;
    final totalCalories = widget.food.calories * quantity;
    final totalProteins = widget.food.proteins * quantity;
    final totalCarbs = widget.food.carbs * quantity;
    final totalFats = widget.food.fats * quantity;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.food.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${totalCalories.toStringAsFixed(0)} kkal',
              style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            // Tampilkan Makro
            Text(
              'P: ${totalProteins.toStringAsFixed(1)}g • K: ${totalCarbs.toStringAsFixed(1)}g • L: ${totalFats.toStringAsFixed(1)}g',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Input Kuantitas dan Waktu Makan
            Row(
              children: [
                // Input Kuantitas
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Jumlah',
                      suffixText: 'porsi (${widget.food.servingUnit})',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => setState(() {}), // Update UI saat diketik
                  ),
                ),
                const SizedBox(width: 10),
                // Dropdown Waktu Makan
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _selectedMealType,
                    items: _mealTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMealType = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Waktu Makan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Log
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final finalQuantity = double.tryParse(_quantityController.text) ?? 1.0;
                  widget.onLog(finalQuantity, _selectedMealType);
                },
                child: const Text('Catat Makanan', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}