import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Untuk CupertinoPicker
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../models/user_model.dart';
import '../../utils/nutritional_calculator.dart'; // Import kalkulator
import '../widgets/question_widgets.dart'; // Import widget pilihan
// TODO: Import controller/service Anda
// import '../../controllers/profile_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class EditTargetGoalsScreen extends StatefulWidget {
  final User user;
  const EditTargetGoalsScreen({super.key, required this.user});

  @override
  State<EditTargetGoalsScreen> createState() => _EditTargetGoalsScreenState();
}

class _EditTargetGoalsScreenState extends State<EditTargetGoalsScreen> {
  // Gunakan Map untuk menyimpan nilai sementara
  late Map<String, dynamic> _editedData;
  // State untuk menyimpan hasil kalkulasi baru
  Map<String, dynamic>? _newCalculations;
  // State untuk checkbox "Terapkan kalkulasi baru"
  bool _applyNewCalculations = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.user.profile ?? _defaultProfile; // Gunakan profil atau default
    _editedData = {
      'height': profile.height.round(),
      'currentWeight': profile.currentWeight.round(),
      'goalWeight': profile.goalWeight.round(),
      'targetDate': null, // TODO: Tambahkan field ini ke model UserProfile jika perlu
      'activityLevel': profile.activityLevel,
      'goals': profile.goals.isNotEmpty ? profile.goals.first : 'Penurunan Berat Badan',
    };
    // Hitung kalkulasi awal saat layar dibuka
    _recalculate();
  }

  // Profil default jika user.profile null
  final UserProfile _defaultProfile = UserProfile(
    gender: 'Pria', age: 25, height: 170, currentWeight: 70,
    goalWeight: 65, activityLevel: 'Cukup Aktif', goals: ['Penurunan Berat Badan'],
    dietaryRestrictions: [], allergies: [],
  );

  // Fungsi untuk menghitung ulang
  void _recalculate() {
    // Ambil data yang diperlukan untuk kalkulasi
    // Data yang tidak ada di form ini (seperti gender, age) diambil dari data user asli
    final profile = widget.user.profile ?? _defaultProfile;

    final results = NutritionalCalculator.calculateNeeds(
      gender: profile.gender,
      age: profile.age,
      height: _editedData['height'] as int,
      currentWeight: _editedData['currentWeight'] as int,
      activityLevel: _editedData['activityLevel'] as String,
      goal: _editedData['goals'] as String,
    );

    setState(() {
      _newCalculations = results;
    });
  }

  // Fungsi untuk menampilkan picker (berat, tinggi, tanggal)
  void _showPicker(BuildContext context, String fieldKey, String title, int min, int max) {
    int initialValue = (_editedData[fieldKey] as int?) ?? min;
    int selectedValue = initialValue;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              _buildPickerHeader(context, title, () {
                setState(() {
                  _editedData[fieldKey] = selectedValue;
                  _recalculate(); // Hitung ulang setelah memilih
                });
                Navigator.pop(context);
              }),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(initialItem: initialValue - min),
                  onSelectedItemChanged: (int index) {
                    selectedValue = min + index;
                  },
                  children: List<Widget>.generate(max - min + 1, (int index) {
                    return Center(child: Text('${min + index}'));
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // TODO: Buat fungsi _showDatePicker jika diperlukan
  Future<void> _showDatePicker(BuildContext context, String fieldKey) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (_editedData[fieldKey] as DateTime?) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 5 tahun ke depan
    );
    if (picked != null) {
      setState(() {
        _editedData[fieldKey] = picked;
        _recalculate(); // Hitung ulang
      });
    }
  }

  // Fungsi untuk menyimpan perubahan
  void _saveChanges() async {
    setState(() => _isLoading = true);

    // TODO: Ambil token, siapkan data, panggil controller/API
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('auth_token');
    // ... (logika API call seperti di EditProfileScreen) ...
    print("Menyimpan data baru: $_editedData");
    print("Terapkan kalkulasi baru: $_applyNewCalculations");
    print("Kalkulasi baru: $_newCalculations");

    await Future.delayed(const Duration(seconds: 2)); // Simulasi

    // TODO: Jika sukses, pop dan kirim data user baru
    // Navigator.pop(context, updatedUser);

    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan disimpan (simulasi)!')),
    );
    Navigator.pop(context, true); // Kirim sinyal sukses
  }


  @override
  Widget build(BuildContext context) {
    // Tentukan string perbedaan berat badan
    String weightDifference = ((_editedData['goalWeight'] as int) - (_editedData['currentWeight'] as int)).toString();
    if (!weightDifference.startsWith('-')) weightDifference = '+$weightDifference';

    // Tentukan string laju (dummy)
    String rate = "-0.1kg/minggu"; // TODO: Hitung ini jika _editedData['targetDate'] ada

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Target & Tujuan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Body Measurements ---
                const Text('Body Measurements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildTextField(
                  label: 'Tinggi Badan(cm)',
                  value: '${_editedData['height']}',
                  onTap: () => _showPicker(context, 'height', 'Pilih Tinggi (cm)', 140, 220),
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  label: 'Berat Badan Saat Ini (kg)',
                  value: '${_editedData['currentWeight']}',
                  onTap: () => _showPicker(context, 'currentWeight', 'Pilih Berat (kg)', 40, 150),
                ),
                const Text('Terakhir diperbarui 12 Mei 2024', style: TextStyle(fontSize: 12, color: Colors.grey)), // Data dummy
                const SizedBox(height: 15),
                _buildTextField(
                  label: 'Target Berat Badan (kg)',
                  value: '${_editedData['goalWeight']}',
                  onTap: () => _showPicker(context, 'goalWeight', 'Pilih Target (kg)', 40, 150),
                ),
                Text('Perbedaan: $weightDifference kg', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 15),
                _buildTextField(
                  label: 'Tanggal Target',
                  value: _editedData['targetDate'] == null ? 'Pilih Tanggal' : DateFormat('d MMM yyyy').format(_editedData['targetDate']),
                  onTap: () => _showDatePicker(context, 'targetDate'),
                ),
                Text('Laju: $rate', style: const TextStyle(fontSize: 12, color: Colors.grey)), // Data dummy
                const SizedBox(height: 30),

                // --- Activity & Goals ---
                const Text('Activity & Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                // Tingkat Aktivitas (Dropdown/Pilihan)
                _buildDropdownField(
                  label: 'Tingkat Aktivitas',
                  value: _editedData['activityLevel'],
                  onTap: () => _showChoicePicker(
                    context,
                    'activityLevel',
                    'Pilih Tingkat Aktivitas',
                    [
                      {'title': 'Menetap', 'description': 'Sedikit atau tidak ada olahraga'},
                      {'title': 'Ringan Aktif', 'description': 'Olahraga ringan 1-3 hari/minggu'},
                      {'title': 'Cukup Aktif', 'description': 'Olahraga sedang 3-5 hari/minggu'},
                      {'title': 'Sangat Aktif', 'description': 'Olahraga berat 6-7 hari/minggu'},
                      {'title': 'Sangat Aktif Sekali', 'description': 'Pekerjaan fisik/olahraga berat'},
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Tujuan Diet (Dropdown/Pilihan)
                _buildDropdownField(
                  label: 'Tujuan Diet',
                  value: _editedData['goals'],
                  onTap: () => _showChoicePicker(
                    context,
                    'goals',
                    'Pilih Tujuan Diet',
                    [
                      {'title': 'Penurunan Berat Badan', 'description': 'Defisit kalori'},
                      {'title': 'Pertahankan Berat Badan', 'description': 'Kalori maintenance'},
                      {'title': 'Pertambahan Berat Badan', 'description': 'Surplus kalori'},
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // --- Peringatan Kalkulasi Ulang ---
                _buildWarningCard(),
                const SizedBox(height: 30),

                // --- Hasil Kalkulasi Baru ---
                if (_newCalculations != null)
                  _buildNewCalculationsSection(_newCalculations!),

                const SizedBox(height: 100), // Padding untuk tombol bawah
              ],
            ),
          ),
          // --- Tombol Aksi di Bawah ---
          _buildBottomActionButtons(),
          // --- Overlay Loading ---
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // === Helper Widgets ===

  // Header untuk picker
  Widget _buildPickerHeader(BuildContext context, String title, VoidCallback onDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: onDone,
            child: const Text('Pilih', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Field input yang terlihat seperti text field tapi memicu picker
  Widget _buildTextField({required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  // Field input untuk pilihan (Tingkat Aktivitas, Tujuan Diet)
  Widget _buildDropdownField({required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
            const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan picker pilihan (menggunakan ChoiceOptionsWithDescription)
  void _showChoicePicker(BuildContext context, String fieldKey, String title, List<Map<String, String>> options) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6, // 60% tinggi layar
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Expanded(
                  child: ChoiceOptionsWithDescription(
                    options: options,
                    initialValue: _editedData[fieldKey],
                    onChanged: (newValue) {
                      // Update nilai, hitung ulang, dan tutup
                      setState(() {
                        _editedData[fieldKey] = newValue;
                        _recalculate();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  // Kartu peringatan
  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perubahan akan menghitung ulang kebutuhan kalori harian Anda!',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900),
                ),
                const SizedBox(height: 5),
                Text(
                  'Pastikan semua informasi sudah benar sebelum menyimpan.',
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bagian hasil kalkulasi baru
  Widget _buildNewCalculationsSection(Map<String, dynamic> calculations) {
    // Format rasio makro
    final protPercent = ((calculations['proteins'] * 4) / calculations['calories'] * 100).round();
    final carbPercent = ((calculations['carbs'] * 4) / calculations['calories'] * 100).round();
    final fatPercent = ((calculations['fats'] * 9) / calculations['calories'] * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hasil Kalkulasi Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        _buildCalculationTile('BMI', calculations['bmi']),
        _buildCalculationTile('BMR', '${calculations['calories']} kalori'),
        _buildCalculationTile('TDEE', '${calculations['calories']} kalori'),
        _buildCalculationTile('Target Harian', '${calculations['calories']} kalori'),
        _buildCalculationTile('Makronutrisi', '$carbPercent% Karbohidrat, $protPercent% Protein, $fatPercent% Lemak'),
        const SizedBox(height: 10),
        // Checkbox "Terapkan"
        CheckboxListTile(
          title: const Text('Terapkan kalkulasi baru', style: TextStyle(fontWeight: FontWeight.w500)),
          value: _applyNewCalculations,
          onChanged: (bool? value) {
            setState(() {
              _applyNewCalculations = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildCalculationTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Tombol Batal dan Simpan di bagian bawah
  Widget _buildBottomActionButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,-2))],
        ),
        child: Row(
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
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('Simpan & Terapkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}