import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Inisialisasi Timezone
    tz.initializeTimeZones();
    // Tentukan lokasi default (bisa diganti jika Anda menyimpan preferensi user)
    // Penting untuk penjadwalan yang akurat
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Pengaturan Inisialisasi untuk Android
    // 'ic_launcher' harus merujuk ke file ikon di android/app/src/main/res/mipmap
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Pengaturan Inisialisasi untuk iOS
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Inisialisasi plugin
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Meminta izin (terutama untuk iOS dan Android 13+)
  Future<void> requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Menjadwalkan notifikasi
  Future<void> scheduleMealNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Pastikan notifikasi hanya dijadwalkan untuk masa depan
    if (scheduledTime.isBefore(DateTime.now())) {
      debugPrint("Notifikasi tidak dijadwalkan: Waktu sudah lewat.");
      return;
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_channel_id', // ID Channel
          'Meal Reminders', // Nama Channel
          channelDescription: 'Notifikasi pengingat waktu makan',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime, // Cocokkan tanggal dan waktu
    );
    debugPrint("Notifikasi dijadwalkan untuk: $scheduledTime dengan ID: $id");
  }

  // Membatalkan semua notifikasi
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    debugPrint("Semua notifikasi dibatalkan.");
  }
}
