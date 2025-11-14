import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../controllers/edit_profile_controller.dart';
import '../widgets/edit_profile/basic_info_section.dart';
import '../widgets/edit_profile/measurements_target_section.dart';
import '../widgets/edit_profile/activity_goal_section.dart';
import '../widgets/edit_profile/preferences_section.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late EditProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EditProfileController(initialUser: widget.user);

    _controller.addListener(_handleControllerState);
  }

  void _handleControllerState() {
    // Cek setelah frame selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Pastikan widget masih ada

      if (_controller.status == EditProfileStatus.success && _controller.updatedUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!')),
        );
        Navigator.pop(context, _controller.updatedUser);
      } else if (_controller.status == EditProfileStatus.failure && _controller.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_controller.errorMessage!)),
        );
      }
    });
  }


  @override
  void dispose() {
    _controller.removeListener(_handleControllerState);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        bool isLoading = _controller.status == EditProfileStatus.loading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
            ),
            title: const Text('Edit Profil & Tujuan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.grey.shade100,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 100.0), // Padding bawah untuk tombol
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gunakan widget section yang sudah dipisah
                    BasicInfoSection(controller: _controller),
                    const SizedBox(height: 30),
                    MeasurementsTargetSection(controller: _controller),
                    const SizedBox(height: 30),
                    ActivityGoalSection(controller: _controller),
                    const SizedBox(height: 30),
                    PreferencesSection(controller: _controller),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Tombol Aksi di Bawah (Fixed)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            side: BorderSide(color: Colors.grey.shade300),
                            foregroundColor: Colors.grey.shade700,
                          ),
                          child: const Text('Batal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _controller.saveChanges, // Panggil saveChanges dari controller
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 2,
                          ),
                          child: isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                              : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Overlay Loading (diambil dari status controller)
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}