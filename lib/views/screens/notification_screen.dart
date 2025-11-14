import 'package:flutter/material.dart';
import '../widgets/notification/notification_tile.dart';
import '../../controllers/notification_controller.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NotificationController();
    _controller.addListener(_handleControllerChanges);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanges);
    _controller.dispose();
    super.dispose();
  }

  void _handleControllerChanges() {
  }

  @override
  Widget build(BuildContext context) {
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
              shadowColor: Colors.grey.shade200),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
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
      return RefreshIndicator(
        onRefresh: _controller.fetchNotifications,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: constraints.maxHeight,
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'Tidak ada notifikasi baru.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _controller.fetchNotifications,
      child: ListView.separated(
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

          return Dismissible(
            key: Key(notification.id), // Key unik
            direction: DismissDirection.endToStart, // Geser dari kanan
            background: Container(
              color: Colors.red.shade400,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
            onDismissed: (direction) {
              _controller.deleteNotification(context, notification.id);
            },
            child: NotificationTile(
              notification: notification,
              onTap: () =>
                  _controller.handleNotificationTap(context, notification),
              onMoreTap: () =>
                  _controller.handleMoreOptionsTap(context, notification),
            ),
          );
        },
      ),
    );
  }
}