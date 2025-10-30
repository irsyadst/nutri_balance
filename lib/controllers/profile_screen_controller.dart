// lib/controllers/profile_screen_controller.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/storage_service.dart';
import '../views/screens/login_screen.dart';
import '../views/screens/edit_profile_screen.dart';

class ProfileScreenController with ChangeNotifier {
  // --- State ---
  late User _currentUser;
  bool _isNotificationEnabled = true;

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

  // --- Getters untuk UI ---
  User get currentUser => _currentUser;
  UserProfile get profile => _currentUser.profile ?? _defaultProfile;
  bool get isNotificationEnabled => _isNotificationEnabled;

  // --- Constructor ---
  ProfileScreenController({required User initialUser}) {
    _currentUser = initialUser;
  }

  // --- Logika Bisnis & Event Handler ---

  /// Mengelola state untuk switch notifikasi
  void toggleNotification(bool value) {
    _isNotificationEnabled = value;
    // TODO: Tambahkan logika untuk menyimpan preferensi notifikasi ini
    print("Notification enabled: $_isNotificationEnabled");
    notifyListeners();
  }

  /// Menangani navigasi ke EditProfileScreen dan memperbarui data saat kembali
  Future<void> navigateToEditProfile(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: _currentUser),
      ),
    );

    // Jika EditProfileScreen mengembalikan User yang diperbarui,
    // update state di controller ini dan beri tahu UI
    if (result is User) {
      _currentUser = result;
      notifyListeners();
      print("ProfileScreenController updated with new user data.");
    } else if (result == true) {
      // Jika hanya mengembalikan true, idealnya kita fetch ulang dari API
      // Untuk saat ini, kita bisa asumsikan data sudah di-pass (walaupun
      // akan lebih baik jika EditProfileController mengembalikan User baru)
      print("Profile updated, ideally refetch user data here.");
      // TODO: Implement fetch user profile from API/Controller
    }
  }

  /// Menangani logika logout
  Future<void> logout(BuildContext context) async {
    // Tampilkan dialog konfirmasi
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
                Navigator.of(context).pop(false); // Kirim false saat batal
              },
            ),
            TextButton(
              child:
              Text('Keluar', style: TextStyle(color: Colors.red.shade600)),
              onPressed: () {
                Navigator.of(context).pop(true); // Kirim true saat konfirmasi
              },
            ),
          ],
        );
      },
    );

    // Lanjutkan logout hanya jika user mengonfirmasi
    if (confirmLogout == true) {
      final storage = StorageService();
      await storage.deleteToken(); // Hapus token

      // Gunakan context.mounted untuk cek sebelum navigasi
      if (context.mounted) {
        // Navigasi ke LoginScreen dan hapus semua halaman sebelumnya
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false, // Hapus semua route
        );
      }
    }
  }
}