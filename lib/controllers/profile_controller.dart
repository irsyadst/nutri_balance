// lib/controllers/profile_controller.dart

import 'package:flutter/material.dart';
import '../models/api_service.dart';
import '../models/user_model.dart';
import '../models/storage_service.dart';
import '../utils/notification_service.dart'; // <--- TAMBAHKAN IMPORT
import '../views/screens/login_screen.dart';
import '../views/screens/edit_profile_screen.dart';

class ProfileController with ChangeNotifier {
  // --- State dari ProfileController (Original) ---
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // --- State dari ProfileScreenController ---
  User? _currentUser;

  // --- State Notifikasi Baru ---
  late final StorageService _storageService;
  late final NotificationService _notificationService;
  bool _isNotificationEnabled = false; // Default false sampai di-load
  bool _isNotificationLoading = true; // State untuk loading

  // Profil default jika user.profile null
  final UserProfile _defaultProfile = UserProfile(
    gender: 'N/A',
    age: 0,
    height: 0,
    currentWeight: 0,
    goalWeight: 0,
    activityLevel: 'N/A',
    goals: const [],
    dietaryRestrictions: const [],
    allergies: const [],
  );

  // --- Getters ---
  bool get isLoading => _isLoading;
  User get currentUser => _currentUser!;
  UserProfile get profile => _currentUser?.profile ?? _defaultProfile;

  // Getters Notifikasi Baru
  bool get isNotificationEnabled => _isNotificationEnabled;
  bool get isNotificationLoading => _isNotificationLoading;

  // --- Constructors ---

  ProfileController() {
    // Constructor ini untuk alur kuesioner
    _storageService = StorageService();
    _notificationService = NotificationService();
  }

  ProfileController.forScreen({required User initialUser}) {
    _currentUser = initialUser;
    _storageService = StorageService();
    _notificationService = NotificationService();
    // Panggil method inisialisasi notifikasi
    _initNotificationState();
  }

  // --- Method Inisialisasi Notifikasi ---

  /// Mengambil preferensi notifikasi dari storage saat layar dibuka
  Future<void> _initNotificationState() async {
    // Asumsi Anda punya method getNotificationPreference di StorageService
    _isNotificationEnabled = await _storageService.getNotificationPreference();
    _isNotificationLoading = false;
    notifyListeners();
  }

  // --- Methods ---

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<User?> saveProfileFromQuestionnaire(
      Map<String, dynamic> answers, String token) async {
    // ... (kode asli saveProfileFromQuestionnaire tetap di sini) ...
    _setLoading(true);

    try {
      final profileData = UserProfile(
        gender: answers['gender'] ?? '',
        age: answers['age'] ?? 0,
        height: (answers['height'] as int? ?? 0).toDouble(),
        currentWeight: (answers['currentWeight'] as int? ?? 0).toDouble(),
        goalWeight: (answers['goalWeight'] as int? ?? 0).toDouble(),
        activityLevel: answers['activityLevel'] ?? '',
        goals: List<String>.from(answers['goals'] ?? []),
        dietaryRestrictions:
        List<String>.from(answers['dietaryRestrictions'] ?? []),
        allergies: List<String>.from(answers['allergies'] ?? []),
      );

      final updatedUser = await _apiService.updateProfile(token, profileData);

      _setLoading(false);
      return updatedUser;
    } catch (e) {
      print("Error di saveProfileFromQuestionnaire: $e");
      _setLoading(false);
      return null;
    }
  }

  // --- Methods dari ProfileScreenController (Diperbarui) ---

  /// Mengelola state & izin untuk switch notifikasi
  Future<void> toggleNotification(BuildContext context, bool value) async {
    if (value == true) {
      // --- Logika MENGAKTIFKAN Notifikasi ---
      // 1. Minta izin ke OS
      bool hasPermission = await _notificationService.requestPermission();

      if (hasPermission) {
        // 2. Izin diberikan: update state, simpan, & jadwalkan notifikasi
        _isNotificationEnabled = true;
        await _storageService.setNotificationPreference(true);
        // Panggil method untuk menjadwalkan notifikasi harian Anda
        await _notificationService.scheduleDailyReminders();
        print("Notifications ENABLED and scheduled.");
      } else {
        // 3. Izin ditolak: Jaga state tetap false & beri tahu user
        _isNotificationEnabled = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin notifikasi ditolak. Aktifkan di Pengaturan Aplikasi.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // --- Logika MEMATIKAN Notifikasi ---
      _isNotificationEnabled = false;
      await _storageService.setNotificationPreference(false);
      // Panggil method untuk membatalkan semua notifikasi
      await _notificationService.cancelAllNotifications();
      print("Notifications DISABLED and cancelled.");
    }
    notifyListeners();
  }


  /// Menangani navigasi ke EditProfileScreen
  Future<void> navigateToEditProfile(BuildContext context) async {
    // ... (kode asli navigateToEditProfile tetap di sini) ...
    if (_currentUser == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: _currentUser!),
      ),
    );

    if (result is User) {
      _currentUser = result;
      notifyListeners();
      print("ProfileController updated with new user data.");
    } else if (result == true) {
      print("Profile updated, ideally refetch user data here.");
    }
  }

  /// Menangani logika logout
  Future<void> logout(BuildContext context) async {
    // ... (kode asli logout tetap di sini) ...
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child:
              Text('Keluar', style: TextStyle(color: Colors.red.shade600)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      await _storageService.deleteToken(); // Hapus token

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      }
    }
  }
}