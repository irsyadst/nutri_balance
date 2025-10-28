import 'package:flutter/material.dart';
import '../../models/user_model.dart';
// Hapus import yang tidak perlu lagi di sini (storage, login)
// import '../../models/storage_service.dart';
// import 'login_screen.dart';
// Import screen tujuan navigasi
import 'edit_profile_screen.dart';
import 'edit_target_goals_screen.dart';
// Import widget-widget baru
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/info_card_row.dart';
import '../widgets/profile/profile_section.dart';
import '../widgets/profile/profile_list_tile.dart';
import '../widgets/profile/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  // Terima User sebagai final, state akan mengelola perubahannya jika perlu
  final User initialUser;
  const ProfileScreen({super.key, required this.initialUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State lokal untuk data user yang bisa berubah
  late User _currentUser;
  bool _isNotificationEnabled = true; // State untuk switch notifikasi

  // Profile default jika user.profile null (bisa jadi konstanta)
  final UserProfile _defaultProfile = UserProfile(
    gender: 'N/A', age: 0, height: 0, currentWeight: 0,
    goalWeight: 0, activityLevel: 'N/A', goals: const [],
    dietaryRestrictions: const [], allergies: const [],
  );

  // Getter untuk profil saat ini atau default
  UserProfile get profile => _currentUser.profile ?? _defaultProfile;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.initialUser; // Inisialisasi state user
  }

  // Fungsi Navigasi ke Edit Profile Lengkap
  void _navigateToEditProfile() async {
    // Tunggu hasil dari EditDataPribadiScreen (bisa berupa User baru atau boolean)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDataPribadiScreen(user: _currentUser),
      ),
    );
    // Jika ada data user baru yang dikembalikan, update state
    if (result is User && mounted) {
      setState(() { _currentUser = result; });
    } else if (result == true && mounted) {
      // Jika hanya mengembalikan true (sukses), mungkin perlu fetch ulang data user
      // TODO: Implement fetch user profile from API/Controller
      print("Profile updated, ideally refetch user data here.");
    }
  }

  // Fungsi Navigasi ke Edit Target & Tujuan
  void _navigateToEditTargetGoals() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTargetGoalsScreen(user: _currentUser),
      ),
    );
    if (result is User && mounted) {
      setState(() { _currentUser = result; });
    } else if (result == true && mounted) {
      // TODO: Implement fetch user profile from API/Controller
      print("Target/Goals updated, ideally refetch user data here.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background sedikit abu-abu
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5, // Shadow tipis di AppBar
        shadowColor: Colors.grey.shade200,
        actions: [
          IconButton( icon: const Icon(Icons.more_horiz, color: Colors.black54), onPressed: () {
            // TODO: Implementasi aksi more options di AppBar
          }, tooltip: 'Opsi Lainnya'),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding( // Padding utama untuk seluruh konten
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch section
            children: [
              // --- Header ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ProfileHeader(
                  user: _currentUser, // Gunakan state _currentUser
                  onEditPressed: _navigateToEditProfile, // Panggil fungsi navigasi
                ),
              ),
              const SizedBox(height: 25),

              // --- Info Cards ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: InfoCardRow(
                  height: profile.height.round(), // Ambil data dari profile getter
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
                    ProfileListTile( // Gunakan widget ProfileListTile
                      icon: Icons.person_outline_rounded, // Ikon lebih rounded
                      title: 'Data Pribadi',
                      onTap: _navigateToEditProfile, // Tetap arahkan ke edit profile utama
                    ),
                    const ProfileListDivider(), // Gunakan divider kustom
                    ProfileListTile(
                      icon: Icons.track_changes_outlined, // Ikon target
                      title: 'Target & Tujuan', // Ubah teks sesuai desain
                      onTap: _navigateToEditTargetGoals, // Arahkan ke edit target
                    ),
                    const ProfileListDivider(),
                    ProfileListTile(
                      icon: Icons.history_rounded, // Ikon history
                      title: 'Riwayat Aktivitas',
                      onTap: () { /* TODO: Navigasi Riwayat Aktivitas */ },
                    ),
                    const ProfileListDivider(),
                    ProfileListTile(
                      icon: Icons.insert_chart_outlined_rounded, // Ikon chart
                      title: 'Statistik Latihan', // Ubah nama jika perlu
                      onTap: () { /* TODO: Navigasi Statistik */ },
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 20), // Dihapus karena ProfileSection sudah ada padding bawah

              // --- Notification Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ProfileSection(
                  title: 'Notifikasi',
                  children: [
                    // Gunakan SwitchListTile langsung di sini
                    SwitchListTile(
                      secondary: Icon(Icons.notifications_outlined, color: Colors.grey[600], size: 24),
                      title: const Text('Notifikasi Pop-up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      value: _isNotificationEnabled,
                      onChanged: (bool value) { setState(() => _isNotificationEnabled = value); },
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    )
                  ],
                ),
              ),
              // const SizedBox(height: 20),

              // --- Other Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ProfileSection(
                  title: 'Lainnya',
                  children: [
                    ProfileListTile( icon: Icons.help_outline_rounded, title: 'Bantuan & FAQ', onTap: () {}),
                    const ProfileListDivider(),
                    ProfileListTile( icon: Icons.info_outline_rounded, title: 'Tentang Aplikasi', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 30), // Jarak sebelum tombol logout

              // --- Logout Button ---
              // Widget LogoutButton sudah termasuk Padding
              const LogoutButton(),

              const SizedBox(height: 40), // Padding bawah akhir
            ],
          ),
        ),
      ),
    );
  }
}


// Ekstensi UserProfile (jika diperlukan oleh EditDataPribadiScreen/EditTargetGoalsScreen)
// Pastikan field ini ada di model asli Anda
extension UserProfileExtension on UserProfile {
  String? get phoneNumber => null;
  DateTime? get dateOfBirth => null;
}