import 'package:flutter/material.dart';

class DetailActivityScreen extends StatelessWidget {
  const DetailActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Aktivitas', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
      ),
      body: const Center(
        child: Text('Konten Detail Aktivitas (Grafik/Riwayat)'),
        // TODO: Tambahkan grafik/list detail aktivitas di sini
      ),
    );
  }
}