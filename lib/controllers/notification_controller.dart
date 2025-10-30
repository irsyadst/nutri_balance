// lib/controllers/notification_controller.dart
import 'package:flutter/material.dart';
import '../models/notification_model.dart'; // Sesuaikan path jika berbeda

// Enum untuk status
enum NotificationStatus { loading, success, failure }

class NotificationController with ChangeNotifier {
  // --- State ---
  NotificationStatus _status = NotificationStatus.loading;
  NotificationStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  // --- Constructor ---
  NotificationController() {
    fetchNotifications(); // Muat data saat controller dibuat
  }

  // --- Logika Fetch Data ---
  Future<void> fetchNotifications() async {
    _status = NotificationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Ganti dengan logika fetch API
      await Future.delayed(const Duration(milliseconds: 300)); // Simulasi
      _notifications = _getDummyData();
      _status = NotificationStatus.success;
    } catch (e) {
      _errorMessage = "Gagal memuat notifikasi.";
      _status = NotificationStatus.failure;
    }
    notifyListeners();
  }

  // --- Logika Event Handler (Dipanggil dari View) ---

  /// Menangani tap pada notifikasi
  void handleNotificationTap(
      BuildContext context, AppNotification notification) {
    // TODO: Implementasi aksi saat notifikasi di-tap (misal, navigasi ke detail)
    print('Notification tapped: ${notification.title}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Membuka notifikasi: ${notification.title} (Belum diimplementasi)')),
    );
  }

  /// Menangani tap pada ikon 'more'
  void handleMoreOptionsTap(
      BuildContext context, AppNotification notification) {
    // TODO: Implementasi menu opsi (misal, tandai sudah dibaca, hapus)
    print('More options tapped for: ${notification.title}');
    // Logika bottom sheet tetap di sini karena memerlukan BuildContext
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.mark_email_read_outlined),
            title: const Text('Tandai sudah dibaca'),
            onTap: () {
              Navigator.pop(context); // Tutup bottom sheet
              // TODO: Panggil logika controller untuk tandai dibaca
              // markAsRead(notification.id);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
            title: Text('Hapus notifikasi',
                style: TextStyle(color: Colors.red.shade400)),
            onTap: () {
              Navigator.pop(context); // Tutup bottom sheet
              // TODO: Panggil logika controller untuk hapus
              // deleteNotification(notification.id);
            },
          ),
        ],
      ),
    );
  }

  // --- Data Dummy (Pindahkan dari view) ---
  final List<AppNotification> _dummyData = const [
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
  ];

  List<AppNotification> _getDummyData() {
    return _dummyData;
  }
}