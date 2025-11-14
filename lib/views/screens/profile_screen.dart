// lib/views/screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../controllers/profile_controller.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/info_card_row.dart';
import '../widgets/profile/profile_section.dart';
import '../widgets/profile/profile_list_tile.dart';
import '../widgets/profile/logout_button.dart';
import 'about_screen.dart';

class ProfileScreen extends StatefulWidget {
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
          appBar: AppBar(
            title: const Text('Profil Saya',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0.5,
            shadowColor: Colors.grey.shade200,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              // Kurangi padding vertikal di sini, karena header sudah punya
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  ProfileHeader(
                    user: currentUser,
                    onEditPressed: () =>
                        _controller.navigateToEditProfile(context),
                  ),

                  const SizedBox(height: 15),

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
                          onTap: () =>
                              _controller.navigateToEditProfile(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileSection(
                      title: 'Notifikasi',
                      children: [
                        _controller.isNotificationLoading
                            ? const ListTile(
                        )
                            : SwitchListTile(
                          secondary: Icon(Icons.notifications_outlined,
                              color: Colors.grey[600], size: 24),
                          title: const Text('Notifikasi Pop-up',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          value: _controller.isNotificationEnabled,
                          onChanged: (bool value) =>
                              _controller.toggleNotification(context, value),
                          activeColor: Theme.of(context).primaryColor,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey.shade300,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ProfileSection(
                      title: 'Lainnya',
                      children: [
                        ProfileListTile(
                            icon: Icons.info_outline_rounded,
                            title: 'Tentang Aplikasi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutScreen(),
                                ),
                              );
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

extension UserProfileExtension on UserProfile {
  String? get phoneNumber => null;
  DateTime? get dateOfBirth => null;
}