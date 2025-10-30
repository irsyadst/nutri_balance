import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Untuk CupertinoPicker
import '../models/user_model.dart';
import '../models/api_service.dart';
import '../models/storage_service.dart';
// Import widget header picker
import '../views/widgets/edit_profile/picker_header.dart';
// Import konstanta dari QuestionnaireController
import 'questionnaire_controller.dart';

// Enum untuk status penyimpanan
enum EditProfileStatus { initial, loading, success, failure }

class EditProfileController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final User initialUser; // User awal

  // --- State ---
  late Map<String, dynamic> _editedData; // Simpan data yang bisa diedit
  Map<String, dynamic> get editedData => Map.unmodifiable(_editedData);

  EditProfileStatus _status = EditProfileStatus.initial;
  EditProfileStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _updatedUser; // Untuk menyimpan hasil update
  User? get updatedUser => _updatedUser;


  // Profil default jika user.profile null
  final UserProfile _defaultProfile = UserProfile(
    gender: 'Pria', age: 25, height: 170, currentWeight: 70,
    goalWeight: 65, activityLevel: 'Cukup Aktif', goals: ['Penurunan Berat Badan'],
    dietaryRestrictions: [], allergies: [],
  );

  EditProfileController({required this.initialUser}) {
    _initializeData();
  }

  void _initializeData() {
    final profile = initialUser.profile ?? _defaultProfile;
    _editedData = {
      'gender': profile.gender,
      'age': profile.age,
      'height': profile.height.round(),
      'currentWeight': profile.currentWeight.round(),
      'goalWeight': profile.goalWeight.round(),
      'activityLevel': profile.activityLevel,
      'goals': profile.goals.isNotEmpty ? profile.goals.first : 'Penurunan Berat Badan',
      'dietaryRestrictions': List<String>.from(profile.dietaryRestrictions),
      'allergies': List<String>.from(profile.allergies),
    };
  }

  // --- Update Data Lokal ---
  void updateField(String key, dynamic value) {
    if (_editedData[key] != value) {
      _editedData[key] = value;
      notifyListeners(); // Beri tahu UI jika ada perubahan
      print("Controller updated $key: $value");
    }
  }

  // --- Logika Picker ---
  void showPicker(BuildContext context, String fieldKey, String title, int min, int max, {String unit = ''}) {
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
                  updateField(fieldKey, selectedValue); // Gunakan updateField
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(initialItem: (initialValue - min).clamp(0, max - min)),
                  onSelectedItemChanged: (int index) {
                    selectedValue = min + index;
                  },
                  children: List<Widget>.generate(max - min + 1, (int index) {
                    return Center(child: Text('${min + index} ${unit}'.trim()));
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showChoicePicker(BuildContext context, String fieldKey, String title, List<Map<String, String>> options) {
    String? currentSelection = _editedData[fieldKey];

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PickerHeader(
                          title: title,
                          onDone: () {
                            if (currentSelection != null) {
                              updateField(fieldKey, currentSelection); // Gunakan updateField
                            }
                            Navigator.pop(context);
                          }
                      ),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: options.map((option) {
                            return RadioListTile<String>(
                              title: Text(option['title']!),
                              subtitle: option['description']!.isNotEmpty ? Text(option['description']!) : null,
                              value: option['title']!,
                              groupValue: currentSelection,
                              onChanged: (String? value) {
                                setModalState(() {
                                  currentSelection = value;
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                            );
                          }).toList(),
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
    );
  }

  void showMultiSelectPicker(BuildContext context, String fieldKey, String title, List<String> allOptions) {
    List<String> currentSelection = (_editedData[fieldKey] as List<dynamic>? ?? []).cast<String>().toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PickerHeader(
                      title: title,
                      onDone: () {
                        updateField(fieldKey, currentSelection); // Gunakan updateField
                        Navigator.pop(context);
                      },
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: allOptions.map((option) {
                          return CheckboxListTile(
                            title: Text(option),
                            value: currentSelection.contains(option),
                            onChanged: (bool? selected) {
                              setModalState(() {
                                if (selected == true) {
                                  currentSelection.add(option);
                                } else {
                                  currentSelection.remove(option);
                                }
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  // --- Logika Simpan ---
  Future<void> saveChanges() async {
    if (_status == EditProfileStatus.loading) return;

    _status = EditProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    String? token = await _storageService.getToken();
    if (token == null) {
      _errorMessage = 'Sesi tidak valid. Silakan login kembali.';
      _status = EditProfileStatus.failure;
      notifyListeners();
      return;
    }

    try {
      final List<String> goalsList;
      if (_editedData['goals'] is String && (_editedData['goals'] as String).isNotEmpty) {
        goalsList = [_editedData['goals'] as String];
      } else {
        goalsList = <String>[];
      }

      final List<String> finalRestrictions = List<String>.from(_editedData['dietaryRestrictions'] ?? []);
      final List<String> finalAllergies = List<String>.from(_editedData['allergies'] ?? []);

      final updatedProfile = UserProfile(
        gender: _editedData['gender'],
        age: _editedData['age'],
        height: (_editedData['height'] as int).toDouble(),
        currentWeight: (_editedData['currentWeight'] as int).toDouble(),
        goalWeight: (_editedData['goalWeight'] as int).toDouble(),
        activityLevel: _editedData['activityLevel'],
        goals: goalsList,
        dietaryRestrictions: finalRestrictions,
        allergies: finalAllergies,
      );

      _updatedUser = await _apiService.updateProfile(token, updatedProfile);

      if (_updatedUser != null) {
        _status = EditProfileStatus.success;
      } else {
        _errorMessage = 'Gagal memperbarui profil. Coba lagi.';
        _status = EditProfileStatus.failure;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _status = EditProfileStatus.failure;
      print("Error saving profile: $e");
    } finally {
      notifyListeners();
    }
  }

  // Helper untuk styling input field (bisa dipindah ke utils)
  static InputDecoration inputDecoration({required String hintText}) {
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
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.blue.withOpacity(0.5), width: 1.5), // Contoh warna fokus
      ),
    );
  }

  // Helper untuk judul section (bisa dipindah ke widget terpisah)
  static Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}