import 'package:flutter/material.dart';
// Import widget baru
import '../widgets/generate_menu/period_radio_option.dart';

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

  // Fungsi untuk menangani perubahan pilihan radio
  void _handleRadioChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedPeriod = newValue;
        // Logika tambahan jika 'Rentang tanggal khusus' dipilih
        if (newValue == 'rentang_khusus') {
          _showDateRangePicker(); // Panggil fungsi untuk menampilkan date range picker
        }
      });
    }
  }

  // Fungsi untuk menampilkan Date Range Picker
  Future<void> _showDateRangePicker() async {
    // TODO: Implementasi date range picker
    print("Menampilkan date range picker...");
    // Contoh menggunakan showDateRangePicker bawaan Flutter
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Batas 1 tahun ke depan
      initialDateRange: DateTimeRange( // Range awal (opsional)
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 6)),
      ),
      builder: (context, child) {
        // Optional: Styling date picker
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // Warna primer tema
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      // Lakukan sesuatu dengan tanggal yang dipilih
      print('Rentang tanggal dipilih: ${pickedRange.start} - ${pickedRange.end}');
      // Anda mungkin ingin menyimpan tanggal ini di state
    } else {
      // Jika user membatalkan, kembalikan pilihan ke opsi sebelumnya jika perlu
      // Atau biarkan 'rentang_khusus' tetap terpilih
      print('Pemilihan rentang tanggal dibatalkan.');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Date range picker (Belum terhubung ke logika simpan)')),
    );
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
        elevation: 1,
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

            // Gunakan widget PeriodRadioOption
            PeriodRadioOption(
              title: 'Hanya hari ini saja',
              value: 'hanya_hari_ini',
              groupValue: _selectedPeriod,
              onChanged: _handleRadioChange,
              activeColor: primaryColor,
            ),
            PeriodRadioOption(
              title: '3 hari ke depan',
              value: '3_hari',
              groupValue: _selectedPeriod,
              onChanged: _handleRadioChange,
              activeColor: primaryColor,
            ),
            PeriodRadioOption(
              title: '1 minggu ke depan',
              value: '1_minggu',
              groupValue: _selectedPeriod,
              onChanged: _handleRadioChange,
              activeColor: primaryColor,
            ),
            PeriodRadioOption(
              title: 'Rentang tanggal khusus',
              value: 'rentang_khusus',
              groupValue: _selectedPeriod,
              onChanged: _handleRadioChange,
              activeColor: primaryColor,
            ),
            // Tambahkan opsi lain jika perlu

            const Spacer(), // Dorong tombol ke bawah

            // Tombol Simpan
            ElevatedButton.icon(
              onPressed: _saveSelection,
              icon: const Icon(Icons.autorenew, color: Colors.white), // Ganti ikon jika perlu
              label: const Text(
                'Hasilkan Menu', // Ganti teks tombol jika perlu
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
            ),
            const SizedBox(height: 20), // Padding bawah tambahan
          ],
        ),
      ),
    );
  }
}