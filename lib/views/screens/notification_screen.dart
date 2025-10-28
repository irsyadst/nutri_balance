import 'package:flutter/material.dart';
// Import model notifikasi
import '../../models/notification_model.dart'; // Sesuaikan path jika berbeda
// Import widget tile notifikasi yang baru
import '../widgets/notification/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // --- Data Notifikasi Statis (Idealnya berasal dari Controller/API) ---
  final List<AppNotification> notifications = const [
    AppNotification(
      title: 'Hei, sudah waktunya makan siang',
      subtitle: 'Sekitar 1 menit yang lalu',
      iconAsset: 'food_plate',
      iconColor: Color(0xFFE8963D), // Oranye
      iconBgColor: Color(0xFFFBEBCD), // Krem Muda
    ),
    AppNotification(
      title: 'Jangan lewatkan latihan tubuh Anda',
      subtitle: 'Sekitar 3 jam yang lalu',
      iconAsset: 'exercise',
      iconColor: Color(0xFF6A82FF), // Biru
      iconBgColor: Color(0xFFEBF0FF), // Biru Muda
    ),
    AppNotification(
      title: 'Hei, mari tambahkan makanan untuk s...', // Judul terpotong
      subtitle: 'Sekitar 3 jam yang lalu',
      iconAsset: 'food_box',
      iconColor: Color(0xFFE8963D),
      iconBgColor: Color(0xFFFBEBCD),
    ),
    AppNotification(
      title: 'Selamat, Anda telah menyelesaikan Ola...', // Judul terpotong
      subtitle: '29 Okt', // Format tanggal lebih singkat
      iconAsset: 'trophy',
      iconColor: Color(0xFF6A82FF),
      iconBgColor: Color(0xFFEBF0FF),
    ),
    AppNotification(
      title: 'Waktunya minum air!',
      subtitle: 'Kemarin',
      iconAsset: 'water_drop', // Contoh ikon lain
      iconColor: Colors.blueAccent,
      iconBgColor: Colors.lightBlueAccent,
    ),
    // Tambahkan notifikasi lain jika perlu
  ];
  // --- Akhir Data Dummy ---


  // Fungsi untuk menangani tap pada notifikasi
  void _handleNotificationTap(BuildContext context, AppNotification notification) {
    // TODO: Implementasi aksi saat notifikasi di-tap (misal, navigasi ke detail)
    print('Notification tapped: ${notification.title}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Membuka notifikasi: ${notification.title} (Belum diimplementasi)')),
    );
  }

  // Fungsi untuk menangani tap pada ikon 'more'
  void _handleMoreOptionsTap(BuildContext context, AppNotification notification) {
    // TODO: Implementasi menu opsi (misal, tandai sudah dibaca, hapus)
    print('More options tapped for: ${notification.title}');
    // Contoh menampilkan bottom sheet sederhana
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap( // Gunakan Wrap agar kontennya minimal
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.mark_email_read_outlined),
            title: const Text('Tandai sudah dibaca'),
            onTap: () {
              Navigator.pop(context); // Tutup bottom sheet
              // Logika tandai dibaca
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
            title: Text('Hapus notifikasi', style: TextStyle(color: Colors.red.shade400)),
            onTap: () {
              Navigator.pop(context); // Tutup bottom sheet
              // Logika hapus
            },
          ),
        ],
      ),
    );
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
        title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5, // Sedikit shadow tipis
        shadowColor: Colors.grey.shade200,
        actions: [
          IconButton( // Gunakan IconButton untuk aksi
            icon: const Icon(Icons.more_horiz, color: Colors.black87),
            onPressed: () {
              // TODO: Implementasi aksi 'more' di AppBar (misal, hapus semua, pengaturan)
              print('App Bar More Options Tapped');
            },
            tooltip: 'Opsi Lainnya',
          ),
          const SizedBox(width: 8), // Padding kanan
        ],
      ),
      // Gunakan ListView.separated untuk menambahkan divider secara otomatis
      body: notifications.isEmpty // Tampilkan pesan jika tidak ada notifikasi
          ? const Center(
        child: Text(
          'Tidak ada notifikasi baru.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.separated(
        itemCount: notifications.length,
        padding: const EdgeInsets.symmetric(vertical: 10), // Padding atas/bawah untuk list
        // Pemisah antar notifikasi
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFF3F4F6), // Warna divider abu-abu muda
          indent: 80, // Indentasi divider agar tidak full width (sesuaikan)
        ),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          // Gunakan widget NotificationTile yang sudah dibuat
          return NotificationTile(
            notification: notification,
            onTap: () => _handleNotificationTap(context, notification),
            onMoreTap: () => _handleMoreOptionsTap(context, notification),
          );
        },
      ),
    );
  }
}