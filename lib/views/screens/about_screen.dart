// lib/views/screens/about_screen.dart

import 'package:flutter/material.dart';

// Impor controller dan widget baru
import '../../controllers/about_controller.dart';
import '../widgets/about/about_content.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late AboutController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AboutController();
  }

  @override
  void dispose() {
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
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return AboutContent(version: _controller.version);
        },
      ),
    );
  }
}