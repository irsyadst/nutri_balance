import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Untuk CupertinoPicker
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../models/user_model.dart';
import '../../utils/nutritional_calculator.dart'; // Import kalkulator
import '../widgets/questionnaire/question_widgets.dart'; // Import widget pilihan
// Import new widgets
import '../widgets/edit_target_goals/picker_header.dart';
import '../widgets/edit_target_goals/picker_trigger_field.dart';
import '../widgets/edit_target_goals/recalculation_warning_card.dart';
import '../widgets/edit_target_goals/new_calculations_section.dart';
import '../widgets/edit_target_goals/bottom_action_buttons.dart';
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
              PickerHeader(
                  title: title,
                  onDone: () {
                    setState(() {
                      _editedData[fieldKey] = selectedValue;
                      _recalculate();
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
                PickerTriggerField(
                  label: 'Tinggi Badan(cm)',
                  value: '${_editedData['height']}',
                  onTap: () => _showPicker(context, 'height', 'Pilih Tinggi (cm)', 140, 220),
                ),
                const SizedBox(height: 15),
                PickerTriggerField(
                  label: 'Berat Badan Saat Ini (kg)',
                  value: '${_editedData['currentWeight']}',
                  onTap: () => _showPicker(context, 'currentWeight', 'Pilih Berat (kg)', 40, 150),
                ),
                const Text('Terakhir diperbarui 12 Mei 2024', style: TextStyle(fontSize: 12, color: Colors.grey)), // Data dummy
                const SizedBox(height: 15),
                PickerTriggerField(
                  label: 'Target Berat Badan (kg)',
                  value: '${_editedData['goalWeight']}',
                  onTap: () => _showPicker(context, 'goalWeight', 'Pilih Target (kg)', 40, 150),
                ),
                Text('Perbedaan: $weightDifference kg', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 15),
                PickerTriggerField(
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
                PickerTriggerField(
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
                PickerTriggerField(
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
                const RecalculationWarningCard(),
                const SizedBox(height: 30),

                // --- Hasil Kalkulasi Baru ---
                if (_newCalculations != null)
                  NewCalculationsSection(
                    calculations: _newCalculations!,
                    applyNewCalculations: _applyNewCalculations,
                    onApplyChanged: (value) => setState(() => _applyNewCalculations = value ?? false),
                  ),
              ],
            ),
          ),
          // --- Tombol Aksi di Bawah ---
          BottomActionButtons(
            isLoading: _isLoading,
            onCancel: () => Navigator.pop(context),
            onSave: _saveChanges,
          ),
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
}