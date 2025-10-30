// lib/views/screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
// Import controller baru
import '../../controllers/profile_screen_controller.dart';
// Import screen tujuan navigasi
import 'edit_profile_screen.dart'; // Masih diperlukan oleh controller
// Import widget-widget
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/info_card_row.dart';
import '../widgets/profile/profile_section.dart';
import '../widgets/profile/profile_list_tile.dart';
import '../widgets/profile/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  final User initialUser;
  const ProfileScreen({super.key, required this.initialUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State lokal untuk controller
  late ProfileScreenController _controller;

  // --- Semua state dan logika lain telah dipindah ke controller ---

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan user awal
    _controller = ProfileScreenController(initialUser: widget.initialUser);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- Semua fungsi logika telah dipindah ke controller ---

  @override
  Widget build(BuildContext context) {
    // Gunakan ListenableBuilder untuk mendengarkan perubahan dari controller
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        // Ambil data terbaru dari controller
        final User currentUser = _controller.currentUser;
        final UserProfile profile = _controller.profile;

        return Scaffold(
          backgroundColor: Colors.grey[100], // Background sedikit abu-abu
          appBar: AppBar(
            title: const Text('Profil',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.5, // Shadow tipis di AppBar
            shadowColor: Colors.grey.shade200,
          ),
          body: SingleChildScrollView(
            child: Padding(
              // Padding utama untuk seluruh konten
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch section
                children: [
                  // --- Header ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileHeader(
                      user: currentUser, // Gunakan data dari controller
                      onEditPressed: () => _controller.navigateToEditProfile(
                          context), // Panggil method controller
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- Info Cards ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: InfoCardRow(
                      height: profile.height.round(), // Ambil data dari controller
                      weight: profile.currentWeight.round(),
                      age: profile.age,
                    ),
                  ),
                  const SizedBox(height: 30), // Jarak ke section

                  // --- Account Section ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileSection(
                      title: 'Akun',
                      children: [
                        ProfileListTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Data Pribadi',
                          onTap: () => _controller.navigateToEditProfile(
                              context), // Panggil method controller
                        ),
                      ],
                    ),
                  ),

                  // --- Notification Section ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileSection(
                      title: 'Notifikasi',
                      children: [
                        SwitchListTile(
                          secondary: Icon(Icons.notifications_outlined,
                              color: Colors.grey[600], size: 24),
                          title: const Text('Notifikasi Pop-up',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          value: _controller
                              .isNotificationEnabled, // Ambil state dari controller
                          onChanged: (bool value) =>
                              _controller.toggleNotification(
                                  value), // Panggil method controller
                          activeColor: Theme.of(context).primaryColor,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        )
                      ],
                    ),
                  ),

                  // --- Other Section ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileSection(
                      title: 'Lainnya',
                      children: [
                        const ProfileListDivider(),
                        ProfileListTile(
                            icon: Icons.info_outline_rounded,
                            title: 'Tentang Aplikasi',
                            onTap: () {
                              // Logika sederhana bisa tetap di sini
                              print("Tapped Tentang Aplikasi");
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30), // Jarak sebelum tombol logout

                  // --- Logout Button ---
                  LogoutButton(
                    // Berikan method logout dari controller
                    onPressed: () => _controller.logout(context),
                  ),

                  const SizedBox(height: 40), // Padding bawah akhir
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Ekstensi UserProfile (jika diperlukan oleh EditDataPribadiScreen/EditTargetGoalsScreen)
// Pastikan field ini ada di model asli Anda
extension UserProfileExtension on UserProfile {
  String? get phoneNumber => null;
  DateTime? get dateOfBirth => null;
}