import 'package:flutter/material.dart';

class ProfilePictureSection extends StatelessWidget {
  final String? imagePath; // Path gambar profil (bisa null)
  final VoidCallback onChangePressed; // Callback saat tombol 'Ubah' ditekan

  const ProfilePictureSection({
    super.key,
    this.imagePath,
    required this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey.shade200,
          // Tampilkan gambar profil jika ada, jika tidak tampilkan placeholder
          backgroundImage: imagePath != null ? AssetImage(imagePath!) : null,
          child: imagePath == null
              ? Icon(Icons.person, size: 40, color: Colors.grey.shade400)
              : null,
        ),
        const SizedBox(width: 20),
        const Text('Foto Profil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const Spacer(),
        OutlinedButton(
          onPressed: onChangePressed, // Gunakan callback
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: Theme.of(context).primaryColor),
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text('Ubah', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}