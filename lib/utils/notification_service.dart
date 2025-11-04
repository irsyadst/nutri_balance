// lib/utils/notification_service.dart

import 'dart:io'; // Diperlukan untuk Pengecekan Platform
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Fungsi top-level ini diperlukan untuk menangani callback
/// saat aplikasi dalam keadaan terminated (background isolate).
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Tangani tap notifikasi saat aplikasi tidak berjalan
  print('Notification tap background: ${notificationResponse.payload}');
  // Anda bisa menambahkan logika navigasi di sini jika menggunakan
  // sistem routing yang mendukungnya (seperti GlobalKey)
}

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  // --- 1. Inisialisasi ---

  /// Panggil method ini di main.dart saat aplikasi dimulai
  Future<void> init() async {
    try {
      // 1. Inisialisasi database timezone
      tz.initializeTimeZones();
      // tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // Opsional

      // 2. Pengaturan khusus untuk Android
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings(
        '@mipmap/ic_launcher', // Icon default aplikasi Anda
      );

      // 3. Gabungkan pengaturan
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
      );

      // 4. Inisialisasi plugin
      await _plugin.initialize(
        settings,
        // Callback saat notifikasi di-tap (app di foreground/background)
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        // Callback saat notifikasi di-tap (app terminated)
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      print("NotificationService (Android Only) berhasil diinisialisasi.");
    } catch (e) {
      print("Error initializing NotificationService: $e");
    }
  }

  // --- 2. Callback Handler ---

  /// Callback untuk tap notifikasi (Android)
  void onDidReceiveNotificationResponse(NotificationResponse response) async {
    // Tangani tap notifikasi
    print('Notification Tapped. Payload: ${response.payload}');

    // CONTOH NAVIGASI SAAT NOTIFIKASI DI-TAP
    // if (response.payload == 'daily_reminder_tap' || response.payload == 'meal_reminder_tap') {
    //   MyApp.navigatorKey.currentState?.pushNamed('/food-log');
    // }
  }

  // --- 3. Izin (Permission) ---

  /// Meminta izin notifikasi kepada pengguna (wajib untuk Android 13+)
  Future<bool> requestPermission() async {
    bool isAllowed = false;

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      // Method yang benar adalah 'requestNotificationsPermission()'
      final bool? result = await androidPlugin?.requestNotificationsPermission();
      isAllowed = result ?? false;
    } else {
      // Untuk platform selain Android, asumsikan diizinkan
      isAllowed = true;
    }

    print("Izin notifikasi diberikan: $isAllowed");
    return isAllowed;
  }

  // --- 4. Penjadwalan Notifikasi ---

  /// Detail notifikasi (Channel Android)
  NotificationDetails _notificationDetails() {
    // Pengaturan Channel Android
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel_id_01', // ID Channel
      'Pengingat Harian NutriBalance', // Nama Channel
      channelDescription: 'Pengingat harian untuk mencatat asupan makanan.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    return const NotificationDetails(
      android: androidDetails,
    );
  }

  /// Menjadwalkan notifikasi harian (contoh: jam 7 malam)
  Future<void> scheduleDailyReminders() async {
    try {
      await _plugin.zonedSchedule(
        0, // ID notifikasi (0 = pengingat harian)
        'Jangan Lupa Catat Makananmu! 🍎', // Judul
        'Buka NutriBalance untuk mencatat progres harianmu.', // Body
        _nextInstanceOfTime(19, 0), // Helper untuk jadwal (Jam 19:00)
        _notificationDetails(),
        androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle, // Mode Android
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
        DateTimeComponents.time, // Ulangi setiap hari di jam yang sama
        payload: 'daily_reminder_tap', // Data saat di-tap
      );
      print("Pengingat harian berhasil dijadwalkan pukul 19:00.");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  /// Menjadwalkan notifikasi untuk waktu makan tertentu (misal: sarapan, makan siang)
  Future<void> scheduleMealNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String payload = 'meal_reminder_tap',
  }) async {
    try {
      final tz.TZDateTime scheduledTZTime = tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      );
      // Pastikan waktu yang dijadwalkan ada di masa depan
      if (scheduledTZTime.isBefore(tz.TZDateTime.now(tz.local))) {
        print(
            "Waktu penjadwalan $title (ID: $id) sudah lewat. Notifikasi dilewati.");
        return;
      }

      await _plugin.zonedSchedule(
        id, // ID unik untuk notifikasi ini (misal: 1=sarapan, 2=makan siang)
        title,
        body,
        scheduledTZTime,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      print(
          "Notifikasi '$title' (ID: $id) berhasil dijadwalkan untuk $scheduledTime.");
    } catch (e) {
      print("Error scheduling meal notification (ID: $id): $e");
    }
  }

  /// Helper untuk mendapatkan instance waktu berikutnya
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // Jika jadwal hari ini sudah lewat, set untuk besok
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // --- 5. Pembatalan Notifikasi ---

  /// Membatalkan semua notifikasi terjadwal
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
    print("Semua notifikasi dibatalkan.");
  }

  /// (Opsional) Membatalkan notifikasi berdasarkan ID
  Future<void> cancelNotificationById(int id) async {
    await _plugin.cancel(id);
    print("Notifikasi dengan ID $id dibatalkan.");
  }

  // --- 6. (Opsional) Notifikasi Tes ---

  /// Menampilkan notifikasi tes secara langsung (misal: 3 detik dari sekarang)
  Future<void> showTestNotification() async {
    print("Menampilkan notifikasi tes...");
    await _plugin.zonedSchedule(
      99, // ID notifikasi tes
      'Notifikasi Tes NutriBalance',
      'Ini adalah notifikasi tes.',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'test_tap',
    );
  }
}