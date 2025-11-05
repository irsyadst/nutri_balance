// lib/views/screens/about_screen.dart

import 'package:flutter/material.dart';
// Hapus package_info, karena sudah di controller
// import 'package:package_info_plus/package_info_plus.dart';

// Impor controller dan widget baru
import '../../controllers/about_controller.dart';
import '../widgets/about/about_content.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // 1. Deklarasikan controller
  late AboutController _controller;

  @override
  void initState() {
    super.initState();
    // 2. Inisialisasi controller
    _controller = AboutController();
  }

  @override
  void dispose() {
    // 3. Dispose controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Tentang Aplikasi',
            style:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.grey.shade200,
      ),
      // 4. Gunakan ListenableBuilder untuk mendengarkan controller
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          // 5. Panggil widget yang sudah dipisah dan kirim data
          return AboutContent(version: _controller.version);
        },
      ),
    );
  }
}