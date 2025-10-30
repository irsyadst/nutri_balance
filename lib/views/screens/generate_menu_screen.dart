import 'package:flutter/material.dart';
import '../../controllers/generate_menu_controller.dart'; // Import controller
// Import widget
import '../widgets/generate_menu/period_radio_option.dart';

class GenerateMenuScreen extends StatefulWidget {
  const GenerateMenuScreen({super.key});

  @override
  State<GenerateMenuScreen> createState() => _GenerateMenuScreenState();
}

class _GenerateMenuScreenState extends State<GenerateMenuScreen> {
  // Buat instance controller
  late GenerateMenuController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GenerateMenuController();
    // Tambahkan listener untuk menangani feedback (SnackBar/Navigasi)
    _controller.addListener(_handleStateChange);
  }

  // Fungsi untuk memberi feedback ke user saat status controller berubah
  void _handleStateChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_controller.status == GenerateMenuStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rencana makan berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );

      } else if (_controller.status == GenerateMenuStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_controller.errorMessage ?? 'Gagal membuat rencana makan.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
  // --- FUNGSI PICKER PINDAH KE SINI ---
  // Fungsi untuk menangani perubahan radio DAN memanggil picker
  void _handleRadioChange(String? newValue, bool isLoading) async {
    if (isLoading || newValue == null) return;

    // Panggil controller untuk update state radio
    _controller.selectPeriod(newValue);

    // Jika memilih rentang khusus, tampilkan date picker DARI SCREEN
    if (newValue == 'rentang_khusus') {
      DateTimeRange? pickedRange = await showDateRangePicker(
        context: context, // Gunakan context dari screen
        firstDate: DateTime.now().subtract(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 90)),
        initialDateRange: _controller.dateRange ??
            DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(const Duration(days: 6)),
            ),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            child: child!,
          );
        },
      );

      // Kirim hasil picker ke controller
      _controller.setDateRange(pickedRange);
    }
  }

  // Fungsi untuk menampilkan picker lagi jika teks tanggal ditekan
  void _showDatePickerAgain(bool isLoading) async {
    if (isLoading) return;
    // Logika sama seperti di _handleRadioChange
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      initialDateRange: _controller.dateRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 6)),
          ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    // Kirim hasil picker ke controller (meskipun mungkin null jika dibatalkan)
    _controller.setDateRange(pickedRange);
  }
  // ------------------------------------

  @override
  void dispose() {
    _controller.removeListener(_handleStateChange); // Hapus listener
    _controller.dispose(); // Hapus controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Gunakan ListenableBuilder untuk update UI berdasarkan state controller
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        bool isLoading = _controller.status == GenerateMenuStatus.loading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              // Nonaktifkan tombol back saat sedang loading
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
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

                // Radio options (sekarang valid karena onChanged di widget nullable)
                PeriodRadioOption(
                  title: 'Hanya hari ini saja',
                  value: 'hanya_hari_ini',
                  groupValue: _controller.selectedPeriod,
                  onChanged: isLoading ? null : (value) => _handleRadioChange(value, isLoading),
                  activeColor: primaryColor,
                ),
                PeriodRadioOption(
                  title: '3 hari ke depan',
                  value: '3_hari',
                  groupValue: _controller.selectedPeriod,
                  onChanged: isLoading ? null : (value) => _handleRadioChange(value, isLoading),
                  activeColor: primaryColor,
                ),
                PeriodRadioOption(
                  title: '1 minggu ke depan',
                  value: '1_minggu',
                  groupValue: _controller.selectedPeriod,
                  onChanged: isLoading ? null : (value) => _handleRadioChange(value, isLoading),
                  activeColor: primaryColor,
                ),
                PeriodRadioOption(
                  title: 'Rentang tanggal khusus',
                  value: 'rentang_khusus',
                  groupValue: _controller.selectedPeriod,
                  onChanged: isLoading ? null : (value) => _handleRadioChange(value, isLoading),
                  activeColor: primaryColor,
                ),

                // Tampilkan field tanggal jika 'rentang_khusus' dipilih
                if (_controller.selectedPeriod == 'rentang_khusus')
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 16.0),
                    child: InkWell(
                      // Panggil fungsi di screen untuk menampilkan picker
                      onTap: () => _showDatePickerAgain(isLoading),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, color: primaryColor, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              _controller.dateRangeText, // Ambil teks tanggal dari controller
                              style: TextStyle(
                                color: _controller.dateRange == null ? Colors.grey[600] : Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const Spacer(), // Dorong tombol ke bawah

                // Tombol Hasilkan Menu
                ElevatedButton.icon(
                  // Panggil method generateMenu di controller
                  onPressed: isLoading ? null : _controller.generateMenu,
                  icon: isLoading
                      ? Container( // Ganti ikon dengan loading indicator
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                  )
                      : const Icon(Icons.autorenew, color: Colors.white),
                  label: Text(
                    isLoading ? 'Menghasilkan...' : 'Hasilkan Menu', // Ubah teks saat loading
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: Colors.grey.shade400, // Warna saat tombol nonaktif
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}