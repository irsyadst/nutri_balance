import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/storage_service.dart';
import 'login_screen.dart'; // Diperlukan untuk navigasi saat logout
import 'edit_profile_screen.dart'; // Untuk tombol Edit utama
// --- 1. IMPORT LAYAR BARU ---
import 'edit_target_goals_screen.dart'; // Import layar Target & Tujuan

class ProfileScreen extends StatefulWidget {
  late User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isNotificationEnabled = true;

  // Profile default
  final UserProfile _defaultProfile = UserProfile(
    gender: 'Pria', age: 25, height: 170, currentWeight: 70,
    goalWeight: 65, activityLevel: 'Sedang', goals: const [],
    dietaryRestrictions: const [], allergies: const [],
  );

  UserProfile get profile => widget.user.profile ?? _defaultProfile;

  // Fungsi Logout
  void _logout(BuildContext context) async {
    final storage = StorageService();
    await storage.deleteToken();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil( context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false, );
    }
  }

  // Fungsi Navigasi ke Edit Profile Lengkap (untuk tombol "Edit")
  void _navigateToEditProfile() async {
    final result = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => EditDataPribadiScreen(user: widget.user),
      ),
    );
    if (result != null && mounted) {
      setState(() { widget.user = result; });
    }
  }

  // --- 2. BUAT FUNGSI NAVIGASI BARU UNTUK TARGET & TUJUAN ---
  void _navigateToEditTargetGoals() async {
    final result = await Navigator.push<User>( // Tunggu hasil User
      context,
      MaterialPageRoute(
        builder: (context) => EditTargetGoalsScreen(user: widget.user), // Arahkan ke layar baru
      ),
    );
    // Jika ada data user baru yang dikembalikan, update state
    if (result != null && mounted) {
      setState(() {
        widget.user = result; // Update data user dengan data terbaru
      });
    }
  }
  // --- AKHIR FUNGSI NAVIGASI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton( icon: const Icon(Icons.more_horiz, color: Colors.black87), onPressed: () {}, ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 25),
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
                _buildProfileTile(
                  Icons.person_outline,
                  'Data Pribadi',
                      () {}, // Tidak ada aksi
                  showArrow: false, // Sembunyikan panah
                ),
                _buildDivider(),
                // --- 3. UBAH ITEM "PENCAPAIAN" ---
                _buildProfileTile(
                  Icons.assignment_turned_in_outlined, // Ikon bisa diganti jika mau
                  'Edit Target & Tujuan', // Ubah teks
                  _navigateToEditTargetGoals, // Panggil fungsi navigasi baru
                ),
                // --- AKHIR PERUBAHAN ---
                _buildDivider(),
                _buildProfileTile(Icons.watch_later_outlined, 'Riwayat Aktivitas', () {}),
                _buildDivider(),
                _buildProfileTile(Icons.bar_chart_outlined, 'Kemajuan Latihan', () {}),
              ],
            ),
            const SizedBox(height: 20),

            // Notification Section
            _buildSectionContainer(
              title: 'Notification',
              children: [_buildNotificationTile()],
            ),
            const SizedBox(height: 20),

            // Other Section
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

            // Tombol Keluar
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              backgroundImage: const AssetImage('assets/images/avatar_placeholder.png'),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome', style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text(widget.user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ],
        ),
        // Tombol Edit di header memanggil _navigateToEditProfile
        ElevatedButton(
          onPressed: _navigateToEditProfile, // Arahkan ke edit profil lengkap
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
          boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5), ), ],
        ),
        child: Column(
          children: [
            Text( value, style: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF007BFF), ), ),
            const SizedBox(height: 5),
            Text( label, style: TextStyle(fontSize: 14, color: Colors.grey[600]), ),
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
            child: Text( title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87), ),
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
      onChanged: (bool value) { setState(() => _isNotificationEnabled = value); },
      secondary: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
      activeColor: const Color(0xFF007BFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  // Modifikasi _buildProfileTile untuk opsi tanpa panah
  Widget _buildProfileTile(IconData icon, String title, VoidCallback onTap, {bool showArrow = true}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: showArrow ? const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey) : null,
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
        child: const Text('Keluar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// Ekstensi UserProfile (jika diperlukan oleh EditDataPribadiScreen/EditTargetGoalsScreen)
extension UserProfileExtension on UserProfile {
  String? get phoneNumber => null;
  DateTime? get dateOfBirth => null;
}