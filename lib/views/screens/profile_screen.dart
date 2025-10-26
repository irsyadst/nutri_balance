import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/storage_service.dart';
import 'login_screen.dart'; // Diperlukan untuk navigasi saat logout
import 'edit_profile_screen.dart'; // <-- 1. IMPORT LAYAR EDIT

class ProfileScreen extends StatefulWidget {
  // --- PERUBAHAN: Jadikan User bisa diubah ---
  // Awalnya: final User user;
  late User user; // Ubah jadi non-final agar bisa diupdate
  // --- AKHIR PERUBAHAN ---

  ProfileScreen({super.key, required this.user}); // Constructor tetap

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNotificationEnabled = true;

  // Profile default (tidak berubah)
  final UserProfile _defaultProfile = UserProfile(
    gender: 'Pria', age: 25, height: 170, currentWeight: 70,
    goalWeight: 65, activityLevel: 'Sedang', goals: const [],
    dietaryRestrictions: const [], allergies: const [],
  );

  // Ambil data profil (tidak berubah)
  UserProfile get profile => widget.user.profile ?? _defaultProfile;

  // Fungsi Logout (tidak berubah)
  void _logout(BuildContext context) async {
    // ... (kode logout tetap sama) ...
    final storage = StorageService();
    await storage.deleteToken(); // Hapus token dari SharedPreferences

    // Navigasi ke halaman login dan hapus semua rute sebelumnya
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  // --- Fungsi Navigasi ke Edit Data Pribadi ---
  void _navigateToEditDataPribadi() async {
    final result = await Navigator.push<User>( // Tunggu hasil User
      context,
      MaterialPageRoute(
        builder: (context) => EditDataPribadiScreen(user: widget.user), // Kirim user saat ini
      ),
    );

    // Jika kembali dengan data User baru (setelah disimpan di EditDataPribadiScreen)
    if (result != null && mounted) {
      setState(() {
        // --- PERUBAHAN: Update state user di ProfileScreen ---
        widget.user = result; // Update data user dengan data terbaru
        // --- AKHIR PERUBAHAN ---
        print("ProfileScreen updated with user: ${result.name}"); // Debug print
      });
    }
  }
  // --- Akhir Fungsi Navigasi ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // ... (AppBar tidak berubah) ...
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black87), // Icon titik tiga
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile dan Info Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(), // Widget ini juga perlu diupdate onTap Edit-nya nanti
                  const SizedBox(height: 25),
                  // Info cards akan otomatis update karena setState
                  _buildInfoCards(
                      height: profile.height.round(),
                      weight: profile.currentWeight.round(),
                      age: profile.age
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Akun Section
            _buildSectionContainer(
              title: 'Akun',
              children: [
                // --- PERUBAHAN: Modifikasi onTap untuk Data Pribadi ---
                _buildProfileTile(
                  Icons.person_outline,
                  'Data Pribadi',
                  _navigateToEditDataPribadi, // Panggil fungsi navigasi
                ),
                // --- AKHIR PERUBAHAN ---
                _buildDivider(),
                _buildProfileTile(Icons.assignment_turned_in_outlined, 'Pencapaian', () {}),
                _buildDivider(),
                _buildProfileTile(Icons.watch_later_outlined, 'Riwayat Aktivitas', () {}),
                _buildDivider(),
                _buildProfileTile(Icons.bar_chart_outlined, 'Kemajuan Latihan', () {}),
              ],
            ),
            const SizedBox(height: 20),

            // Notification Section (tidak berubah)
            _buildSectionContainer(
              title: 'Notification',
              children: [_buildNotificationTile()],
            ),
            const SizedBox(height: 20),

            // Other Section (tidak berubah)
            _buildSectionContainer(
              title: 'Other',
              children: [
                _buildProfileTile(Icons.mail_outline, 'Contact Us', () {}),
                _buildDivider(),
                _buildProfileTile(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
                _buildDivider(),
                _buildProfileTile(Icons.settings_outlined, 'Settings', () {}),
              ],
            ),
            const SizedBox(height: 40),

            // Tombol Keluar (tidak berubah)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildLogoutButton(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // === WIDGET PEMBANGUN (BUILDERS) ===

  Widget _buildProfileHeader() {
    // Di sini juga perlu update tombol Edit jika ingin edit keseluruhan profil
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              // TODO: Gunakan gambar profil asli jika ada
              backgroundImage: const AssetImage('assets/images/avatar_placeholder.png'),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  widget.user.name, // Akan otomatis update setelah setState
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),

        // Tombol Edit (TODO: Arahkan ke EditProfileScreen utama jika ada)
        ElevatedButton(
          onPressed: () {
            // TODO: Arahkan ke layar edit profil utama (jika beda dengan edit data pribadi)
            // Misalnya: _navigateToEditProfile();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tombol Edit Utama (Belum dihubungkan)'))
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007BFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            elevation: 0,
          ),
          child: const Text('Edit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // --- Widget builder lainnya (_buildInfoCards, _buildInfoCard, _buildSectionContainer,
  // --- _buildNotificationTile, _buildProfileTile, _buildDivider, _buildLogoutButton)
  // --- tidak perlu diubah dari kode Anda sebelumnya ---
  Widget _buildInfoCards({required int height, required int weight, required int age}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard('$height cm', 'Height'),
        const SizedBox(width: 10),
        _buildInfoCard('$weight kg', 'Weight'),
        const SizedBox(width: 10),
        _buildInfoCard('$age yo', 'Age'),
      ],
    );
  }

  Widget _buildInfoCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BFF), // Warna biru untuk nilai
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile() {
    return SwitchListTile(
      title: const Text('Pop-up Notifikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      value: _isNotificationEnabled,
      onChanged: (bool value) {
        setState(() => _isNotificationEnabled = value);
      },
      secondary: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
      activeColor: const Color(0xFF007BFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(height: 1, thickness: 1, color: Colors.grey[100]),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _logout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF5350),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text(
            'Keluar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}

// --- Tambahkan ekstensi pada UserProfile jika belum ada ---
// Pastikan file user_model.dart Anda memiliki field ini
extension UserProfileExtension on UserProfile {
  // Tambahkan field ini jika belum ada di model Anda
  String? get phoneNumber => null; // Ganti null dengan field asli jika ada
  DateTime? get dateOfBirth => null; // Ganti null dengan field asli jika ada
}