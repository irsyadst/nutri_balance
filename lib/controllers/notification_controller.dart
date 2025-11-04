import 'package:flutter/material.dart';
import '../models/notification_model.dart';
// --- IMPOR BARU ---
import '../models/api_service.dart';
import '../models/storage_service.dart';
// --- AKHIR IMPOR ---

// Enum untuk status
enum NotificationStatus { loading, success, failure }

class NotificationController with ChangeNotifier {
  // --- TAMBAHAN BARU ---
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  // --- AKHIR TAMBAHAN ---

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

  // --- Logika Fetch Data (Diperbarui) ---
  Future<void> fetchNotifications() async {
    _status = NotificationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Ambil token
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception("Sesi tidak valid. Silakan login kembali.");
      }

      // 2. Panggil API
      _notifications = await _apiService.getNotifications(token);

      _status = NotificationStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _status = NotificationStatus.failure;
    }
    notifyListeners();
  }
  // --- Akhir Perbaruan ---

  // --- Logika Event Handler (Dipanggil dari View) ---

  void handleNotificationTap(
      BuildContext context, AppNotification notification) {
    // TODO: Implementasi aksi (misal: tandai sudah dibaca di API)
    print('Notification tapped: ${notification.title}');
    // Panggil API untuk menandai 'isRead = true'
  }

  void handleMoreOptionsTap(
      BuildContext context, AppNotification notification) {
    print('More options tapped for: ${notification.title}');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.mark_email_read_outlined),
            title: const Text('Tandai sudah dibaca'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Panggil API 'markAsRead(notification.id)'
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
            title: Text('Hapus notifikasi',
                style: TextStyle(color: Colors.red.shade400)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Panggil API 'deleteNotification(notification.id)'
            },
          ),
        ],
      ),
    );
  }

// --- HAPUS: Data Dummy tidak diperlukan lagi ---
// List<AppNotification> _getDummyData() { ... }
}

