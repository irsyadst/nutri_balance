import 'package:flutter/material.dart';
// Import model notifikasi
import '../../models/notification_model.dart'; // Sesuaikan path jika berbeda
// Import widget tile notifikasi
import '../widgets/notification/notification_tile.dart';
// Import controller baru
import '../../controllers/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // 1. Inisialisasi controller
  late NotificationController _controller;

  // --- Data Notifikasi Statis (PINDAH KE CONTROLLER) ---
  // final List<AppNotification> notifications = const [ ... ];

  @override
  void initState() {
    super.initState();
    _controller = NotificationController();
    // (Opsional) Tambahkan listener untuk error
    _controller.addListener(_handleControllerChanges);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanges);
    _controller.dispose();
    super.dispose();
  }

  // (Opsional) Listener untuk menangani error
  void _handleControllerChanges() {
    if (_controller.status == NotificationStatus.failure &&
        _controller.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_controller.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  // --- Fungsi (PINDAH KE CONTROLLER) ---
  // void _handleNotificationTap(BuildContext context, AppNotification notification) { ... }
  // void _handleMoreOptionsTap(BuildContext context, AppNotification notification) { ... }

  @override
  Widget build(BuildContext context) {
    // 2. Gunakan ListenableBuilder untuk mendengarkan controller
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Notifikasi',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            shadowColor: Colors.grey.shade200
          ),
          // 3. Bangun body berdasarkan status controller
          body: _buildBody(),
        );
      },
    );
  }

  // Helper untuk membangun body berdasarkan status
  Widget _buildBody() {
    // 4. Ambil data dari controller
    final notifications = _controller.notifications;

    if (_controller.status == NotificationStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.status == NotificationStatus.failure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                _controller.errorMessage ?? 'Gagal memuat notifikasi.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                onPressed: _controller.fetchNotifications,
              ),
            ],
          ),
        ),
      );
    }

    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada notifikasi baru.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Tampilkan ListView jika data sukses dan tidak kosong
    return ListView.separated(
      itemCount: notifications.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF3F4F6),
        indent: 80,
      ),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationTile(
          notification: notification,
          // 5. Panggil method dari controller
          onTap: () => _controller.handleNotificationTap(context, notification),
          onMoreTap: () =>
              _controller.handleMoreOptionsTap(context, notification),
        );
      },
    );
  }
}