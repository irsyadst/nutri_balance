import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../models/user_model.dart'; // Sesuaikan path model User Anda
// TODO: Import Controller atau Service untuk update data
// import '../../controllers/profile_controller.dart';
// import '../../models/api_service.dart';

class EditDataPribadiScreen extends StatefulWidget {
  // Terima data user yang sedang login
  final User user;

  const EditDataPribadiScreen({super.key, required this.user});

  @override
  State<EditDataPribadiScreen> createState() => _EditDataPribadiScreenState();
}

class _EditDataPribadiScreenState extends State<EditDataPribadiScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controller untuk field yang bisa diedit
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedGender;
  DateTime? _selectedDate; // Untuk tanggal lahir

  bool _isLoading = false; // Untuk indikator loading saat menyimpan

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data user saat ini
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.profile?.phoneNumber ?? ''); // Ambil nomor HP jika ada
    _selectedGender = widget.user.profile?.gender ?? 'Wanita'; // Ambil gender atau default
    _selectedDate = widget.user.profile?.dateOfBirth; // Ambil tanggal lahir jika ada
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- Fungsi untuk menampilkan Date Picker ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900), // Batas awal tanggal
      lastDate: DateTime.now(), // Batas akhir tanggal (hari ini)
      builder: (context, child) {
        // Optional: Styling date picker
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // Warna biru
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- Fungsi untuk menyimpan perubahan ---
  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: Ambil token autentikasi (misal dari SharedPreferences)
      // final String? token = await StorageService().getToken();
      // if (token == null) { /* Handle error */ setState(() => _isLoading = false); return; }

      // TODO: Siapkan data yang akan dikirim ke backend
      final updatedData = {
        'name': _nameController.text,
        'phoneNumber': _phoneController.text.isNotEmpty ? _phoneController.text : null, // Kirim null jika kosong
        'gender': _selectedGender,
        'dateOfBirth': _selectedDate?.toIso8601String(), // Kirim format ISO String
        // Tambahkan field lain jika perlu
      };

      print('Data yang akan disimpan: $updatedData');

      // --- SIMULASI PANGGILAN API (Ganti dengan kode asli) ---
      // bool success = await ProfileController().updatePersonalData(token, updatedData);
      await Future.delayed(const Duration(seconds: 2)); // Simulasi delay
      bool success = true; // Anggap sukses
      // --- AKHIR SIMULASI ---

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pribadi berhasil diperbarui!')),
        );
        // Kembali ke layar sebelumnya (ProfileScreen) dan kirim data user baru jika API mengembalikannya
        // Contoh: Navigator.pop(context, updatedUserFromApi);
        Navigator.pop(context, true); // Kirim 'true' untuk menandakan sukses
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data.')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Data Pribadi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1, // Beri sedikit shadow
        shadowColor: Colors.grey.shade100,
      ),
      body: Stack( // Gunakan Stack agar bisa menampilkan overlay loading
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Foto Profil ---
                  _buildProfilePictureSection(),
                  const SizedBox(height: 30),

                  // --- Nama Lengkap ---
                  const Text('Nama Lengkap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(hintText: 'Masukkan nama lengkap'),
                    validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 20),

                  // --- Email ---
                  const Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: widget.user.email, // Tampilkan email
                    readOnly: true, // Tidak bisa diedit
                    decoration: _inputDecoration(hintText: 'Email').copyWith(
                      fillColor: Colors.grey.shade100, // Warna berbeda untuk read-only
                    ),
                    style: TextStyle(color: Colors.grey.shade600), // Warna teks abu-abu
                  ),
                  const SizedBox(height: 5),
                  Text('Email tidak dapat diubah', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 20),

                  // --- No HP ---
                  const Text('No HP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration(hintText: 'Masukkan nomor HP'),
                    keyboardType: TextInputType.phone,
                    // Tidak ada validator, karena opsional
                  ),
                  const SizedBox(height: 5),
                  Text('Nomor HP bersifat opsional', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 30),

                  // --- Jenis Kelamin ---
                  const Text('Jenis Kelamin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _buildGenderRadio('Wanita'),
                  _buildGenderRadio('Pria'),
                  const SizedBox(height: 30),

                  // --- Tanggal Lahir ---
                  const Text('Tanggal Lahir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  InkWell( // Buat area bisa diklik
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: _inputDecoration(
                        hintText: _selectedDate == null ? 'Pilih Tanggal' : DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!),
                      ).copyWith(
                        suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                      ),
                      child: _selectedDate == null
                          ? null // Biarkan kosong jika belum dipilih
                          : Text( // Tampilkan tanggal yang dipilih
                        DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // --- Tombol Aksi ---
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context), // Tombol Batal
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            side: BorderSide(color: Colors.grey.shade300),
                            foregroundColor: Colors.grey.shade700,
                          ),
                          child: const Text('Batal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveChanges, // Tombol Simpan
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor, // Warna biru
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 2,
                          ),
                          child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // --- Overlay Loading ---
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  // === Helper Widgets ===

  Widget _buildProfilePictureSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey.shade200,
          // TODO: Ganti dengan gambar profil asli user
          backgroundImage: const AssetImage('assets/images/avatar_placeholder.png'),
          // child: Icon(Icons.person, size: 40, color: Colors.grey.shade400),
        ),
        const SizedBox(width: 20),
        const Text('Foto Profil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const Spacer(),
        OutlinedButton(
          onPressed: () {
            // TODO: Implementasi logika ubah foto profil (ambil dari galeri/kamera)
            print('Tombol Ubah Foto diklik');
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: Theme.of(context).primaryColor),
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text('Ubah', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // Helper untuk styling input field
  InputDecoration _inputDecoration({required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFF3F4F6), // Warna abu muda
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      suffixIcon: suffixIcon,
      // Styling untuk error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  // Helper untuk Radio Button Jenis Kelamin
  Widget _buildGenderRadio(String gender) {
    return RadioListTile<String>(
      title: Text(gender),
      value: gender,
      groupValue: _selectedGender,
      onChanged: (String? value) {
        setState(() {
          _selectedGender = value;
        });
      },
      activeColor: Theme.of(context).primaryColor, // Warna biru
      contentPadding: EdgeInsets.zero, // Hapus padding default
      controlAffinity: ListTileControlAffinity.leading, // Radio di kiri
      visualDensity: VisualDensity.compact, // Buat lebih rapat
    );
  }
}

// --- Tambahkan ekstensi pada UserProfile jika belum ada ---
// Pastikan file user_model.dart Anda memiliki field ini
extension UserProfileExtension on UserProfile {
  // Tambahkan field ini jika belum ada di model Anda
  String? get phoneNumber => null; // Ganti null dengan field asli jika ada
  DateTime? get dateOfBirth => null; // Ganti null dengan field asli jika ada
}