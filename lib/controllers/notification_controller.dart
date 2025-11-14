// lib/controllers/notification_controller.dart

import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../models/api_service.dart';
import '../models/storage_service.dart';

// Enum untuk status
enum NotificationStatus { loading, success, failure }

class NotificationController with ChangeNotifier {
  // --- Dependensi ---
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // --- State ---
  NotificationStatus _status = NotificationStatus.loading;
  NotificationStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  // --- Constructor ---
  NotificationController() {
    fetchNotifications();
  }

  // --- Helper ---
  Future<String> _getAuthToken() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception("Sesi tidak valid. Silakan login kembali.");
    }
    return token;
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.replaceAll("Exception: ", "")),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- Logika Fetch Data ---
  Future<void> fetchNotifications() async {
    _status = NotificationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      _notifications = await _apiService.getNotifications(token);
      _status = NotificationStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _status = NotificationStatus.failure;
    }
    notifyListeners();
  }

  // --- Logika Aksi (Mark as Read) ---
  Future<void> markAsRead(BuildContext context, String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);

    if (index == -1 || _notifications[index].isRead == true) return;
    final bool oldStatus = _notifications[index].isRead;

    _notifications[index].isRead = true;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      await _apiService.markNotificationAsRead(token, notificationId);
    } catch (e) {
      _notifications[index].isRead = oldStatus;
      notifyListeners();
      _showErrorSnackbar(context, "Gagal menandai notifikasi: ${e.toString()}");
    }
  }

  // --- Logika Aksi (Delete) ---
  Future<void> deleteNotification(BuildContext context, String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;

    // Simpan notifikasi untuk rollback
    final notificationToRemove = _notifications.removeAt(index);
    notifyListeners(); // Update UI

    try {
      final token = await _getAuthToken();
      await _apiService.deleteNotification(token, notificationId);
    } catch (e) {
      _notifications.insert(index, notificationToRemove);
      notifyListeners();
      _showErrorSnackbar(context, "Gagal menghapus notifikasi: ${e.toString()}");
    }
  }

  // --- Event Handler (Dipanggil dari View) ---

  void handleNotificationTap(BuildContext context, AppNotification notification) {

    print('Notification tapped: ${notification.title}');
    markAsRead(context, notification.id);
  }

  void handleMoreOptionsTap(BuildContext context, AppNotification notification) {
    print('More options tapped for: ${notification.title}');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Wrap(
        children: <Widget>[
          // Hanya tampilkan jika belum dibaca
          if (notification.isRead != true)
            ListTile(
              leading: const Icon(Icons.mark_email_read_outlined),
              title: const Text('Tandai sudah dibaca'),
              onTap: () {
                Navigator.pop(context);
                markAsRead(context, notification.id);
              },
            ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
            title: Text('Hapus notifikasi',
                style: TextStyle(color: Colors.red.shade400)),
            onTap: () {
              Navigator.pop(context);
              deleteNotification(context, notification.id);
            },
          ),
        ],
      ),
    );
  }

  // --- Logika untuk menyimpan notifikasi BARU ---
  Future<void> createNotification(BuildContext context, String title,
      String message, String iconAsset) async {
    try {
      final token = await _getAuthToken();
      final newNotification = await _apiService.createNotification(
        token,
        title,
        message,
        iconAsset,
      );

      _notifications.insert(0, newNotification);
      notifyListeners();
    } catch (e) {
      _showErrorSnackbar(
          context, "Gagal menyimpan notifikasi: ${e.toString()}");
    }
  }
}