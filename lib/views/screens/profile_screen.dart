// lib/views/screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../controllers/profile_controller.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/info_card_row.dart';
import '../widgets/profile/profile_section.dart';
import '../widgets/profile/profile_list_tile.dart';
import '../widgets/profile/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  // ... (kode asli) ...
  final User initialUser;
  const ProfileScreen({super.key, required this.initialUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController.forScreen(initialUser: widget.initialUser);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final User currentUser = _controller.currentUser;
        final UserProfile profile = _controller.profile;

        return Scaffold(
          // ... (kode AppBar dan bagian atas body) ...
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ... (ProfileHeader, InfoCardRow, Account Section) ...
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileHeader(
                      user: currentUser,
                      onEditPressed: () => _controller.navigateToEditProfile(context),
                    ),
                  ),
                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: InfoCardRow(
                      height: profile.height.round(),
                      weight: profile.currentWeight.round(),
                      age: profile.age,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileSection(
                      title: 'Akun',
                      children: [
                        ProfileListTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Data Pribadi',
                          onTap: () => _controller.navigateToEditProfile(context),
                        ),
                      ],
                    ),
                  ),

                  // --- Notification Section (DIPERBARUI) ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileSection(
                      title: 'Notifikasi',
                      children: [
                        // Tampilkan loading indicator atau switch
                        _controller.isNotificationLoading
                            ? const ListTile(
                          leading: Icon(Icons.notifications_outlined),
                          title: Text('Notifikasi Pop-up'),
                          trailing: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                        )
                            : SwitchListTile(
                          secondary: Icon(Icons.notifications_outlined,
                              color: Colors.grey[600], size: 24),
                          title: const Text('Notifikasi Pop-up',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          value: _controller.isNotificationEnabled,
                          // Kirim 'context' ke controller
                          onChanged: (bool value) =>
                              _controller.toggleNotification(context, value),
                          activeColor: Theme.of(context).primaryColor,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        )
                      ],
                    ),
                  ),
                  // --- End of Notification Section ---

                  // ... (Other Section dan Logout Button) ...
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
                              print("Tapped Tentang Aplikasi");
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  LogoutButton(
                    onPressed: () => _controller.logout(context),
                  ),
                  const SizedBox(height: 40),
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