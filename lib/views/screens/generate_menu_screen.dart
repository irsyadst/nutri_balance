import 'package:flutter/material.dart';

class GenerateMenuScreen extends StatefulWidget {
  const GenerateMenuScreen({super.key});

  @override
  State<GenerateMenuScreen> createState() => _GenerateMenuScreenState();
}

class _GenerateMenuScreenState extends State<GenerateMenuScreen> {
  // State untuk menyimpan pilihan radio button
  String _selectedPeriod = 'hanya_hari_ini'; // Nilai default

  // Fungsi untuk menangani penyimpanan
  void _saveSelection() {
    print('Periode dipilih: $_selectedPeriod');
    // TODO: Tambahkan logika untuk generate menu berdasarkan _selectedPeriod

    // Tampilkan SnackBar atau lakukan navigasi setelah menyimpan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Menu untuk $_selectedPeriod sedang dibuat... (Logika belum ada)')),
    );
    // Kembali ke layar sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Hasilkan Menu Otomatis',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1, // Beri sedikit shadow
        shadowColor: Colors.grey.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih periode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Opsi Radio Button
            _buildRadioOption(
              title: 'Hanya hari ini saja',
              value: 'hanya_hari_ini',
              activeColor: primaryColor,
            ),
            _buildRadioOption(
              title: '3 hari ke depan',
              value: '3_hari',
              activeColor: primaryColor,
            ),
            _buildRadioOption(
              title: '1 minggu ke depan',
              value: '1_minggu',
              activeColor: primaryColor,
            ),
            _buildRadioOption(
              title: 'Rentang tanggal khusus',
              value: 'rentang_khusus',
              activeColor: primaryColor,
            ),

            const Spacer(), // Dorong tombol ke bawah

            // Tombol Simpan
            ElevatedButton.icon(
              onPressed: _saveSelection,
              icon: const Icon(Icons.save_outlined, color: Colors.white), // Contoh ikon
              label: const Text(
                'Simpan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Warna biru
                minimumSize: const Size(double.infinity, 55), // Lebar penuh
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat RadioListTile yang stylish
  Widget _buildRadioOption({
    required String title,
    required String value,
    required Color activeColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Latar belakang abu-abu muda
        borderRadius: BorderRadius.circular(15),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        value: value,
        groupValue: _selectedPeriod,
        onChanged: (String? newValue) {
          setState(() {
            _selectedPeriod = newValue!;
            // TODO: Jika 'Rentang tanggal khusus' dipilih, tampilkan date range picker
            if (newValue == 'rentang_khusus') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tampilkan date range picker (Belum diimplementasi)')),
              );
            }
          });
        },
        activeColor: activeColor,
        controlAffinity: ListTileControlAffinity.trailing, // Radio di kanan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}