import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../models/user_model.dart'; // Sesuaikan path model User Anda
// Import widget baru
import '../widgets/edit_profile/profile_picture_section.dart';
import '../widgets/edit_profile/gender_radio_option.dart';
// TODO: Import Controller atau Service untuk update data
// import '../../controllers/profile_controller.dart';
// import '../../models/api_service.dart';

class EditDataPribadiScreen extends StatefulWidget {
  final User user;
  const EditDataPribadiScreen({super.key, required this.user});

  @override
  State<EditDataPribadiScreen> createState() => _EditDataPribadiScreenState();
}

class _EditDataPribadiScreenState extends State<EditDataPribadiScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    // Gunakan null-aware operator '??' untuk default value jika profile null
    _phoneController = TextEditingController(text: widget.user.profile?.phoneNumber ?? '');
    _selectedGender = widget.user.profile?.gender ?? 'Wanita'; // Default jika null
    _selectedDate = widget.user.profile?.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleChangePicture() {
    // TODO: Implementasi logika ubah foto profil (ambil dari galeri/kamera)
    print('Tombol Ubah Foto diklik');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logika ubah foto belum diimplementasi')),
    );
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: Ambil token autentikasi (misal dari SharedPreferences)
      // final String? token = await StorageService().getToken();
      // if (token == null) { /* Handle error */ setState(() => _isLoading = false); return; }

      final updatedData = {
        'name': _nameController.text,
        'phoneNumber': _phoneController.text.isNotEmpty ? _phoneController.text : null,
        'gender': _selectedGender,
        'dateOfBirth': _selectedDate?.toIso8601String(),
      };

      print('Data yang akan disimpan: $updatedData');

      // --- SIMULASI PANGGILAN API (Ganti dengan kode asli) ---
      // bool success = await ProfileController().updatePersonalData(token, updatedData);
      await Future.delayed(const Duration(seconds: 2));
      bool success = true;
      // --- AKHIR SIMULASI ---

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pribadi berhasil diperbarui!')),
        );
        // TODO: Kirim data user yang diperbarui kembali jika API mengembalikannya
        // User updatedUser = User(...); // User baru dari response API
        // Navigator.pop(context, updatedUser);
        Navigator.pop(context, true); // Kirim 'true' untuk menandakan sukses
      }/* else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data.')),
        );
      }*/
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
        elevation: 1,
        shadowColor: Colors.grey.shade100,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gunakan widget ProfilePictureSection
                  ProfilePictureSection(
                    // TODO: Ganti dengan path gambar profil user jika ada
                    imagePath: 'assets/images/avatar_placeholder.png', // Contoh placeholder
                    onChangePressed: _handleChangePicture,
                  ),
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
                    initialValue: widget.user.email,
                    readOnly: true,
                    decoration: _inputDecoration(hintText: 'Email').copyWith(
                      fillColor: Colors.grey.shade100,
                    ),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 5),
                  Text('Email tidak dapat diubah', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 20),

                  // --- No HP ---
                  const Text('No HP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration(hintText: 'Masukkan nomor HP (Opsional)'),
                    keyboardType: TextInputType.phone,
                  ),
                  // const SizedBox(height: 5), // Komen jika tidak perlu teks opsional
                  // Text('Nomor HP bersifat opsional', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 30),

                  // --- Jenis Kelamin ---
                  const Text('Jenis Kelamin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  // Gunakan widget GenderRadioOption
                  GenderRadioOption(
                    title: 'Wanita',
                    value: 'Wanita',
                    groupValue: _selectedGender,
                    onChanged: (value) => setState(() => _selectedGender = value),
                    activeColor: Theme.of(context).primaryColor,
                  ),
                  GenderRadioOption(
                    title: 'Pria',
                    value: 'Pria',
                    groupValue: _selectedGender,
                    onChanged: (value) => setState(() => _selectedGender = value),
                    activeColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 30),

                  // --- Tanggal Lahir ---
                  const Text('Tanggal Lahir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      // Gunakan _inputDecoration sebagai basis
                      decoration: _inputDecoration(
                        // Tampilkan teks hint atau tanggal yang diformat
                        hintText: _selectedDate == null ? 'Pilih Tanggal' : DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!),
                      ).copyWith(
                        // Tambahkan ikon kalender sebagai suffix
                        suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                        // Hilangkan teks internal jika tanggal sudah dipilih agar hintText terlihat
                        hintStyle: _selectedDate == null
                            ? TextStyle(color: Colors.grey.shade400)
                            : const TextStyle(color: Colors.black, fontSize: 16), // Tampilkan tanggal dengan gaya teks normal
                      ),
                      // Kosongkan child agar hintText dari decoration yang tampil
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // --- Tombol Aksi ---
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                          onPressed: _isLoading ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 2,
                          ),
                          // Tampilkan loading indicator di tombol jika sedang loading
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                          )
                              : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Overlay Loading
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

  // Helper untuk styling input field (bisa tetap di sini atau dipindah ke file util terpisah)
  InputDecoration _inputDecoration({required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      suffixIcon: suffixIcon,
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
}

// --- Pastikan ekstensi UserProfile ada ---
// (Tetap diperlukan jika model UserProfile belum memiliki field ini)
extension UserProfileExtension on UserProfile {
  String? get phoneNumber => null; // Ganti null dengan getter field asli
  DateTime? get dateOfBirth => null; // Ganti null dengan getter field asli
}