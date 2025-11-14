// lib/utils/notification_service.dart

import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('Notification tap background: ${notificationResponse.payload}');

}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();


  Future<void> init() async {
    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
      );

      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      print("NotificationService (Android Only) berhasil diinisialisasi.");
    } catch (e) {
      print("Error initializing NotificationService: $e");
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) async {

    print('Notification Tapped. Payload: ${response.payload}');
  }

  Future<bool> requestPermission() async {
    bool isAllowed = false;

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? result = await androidPlugin?.requestNotificationsPermission();
      isAllowed = result ?? false;
    } else {
      isAllowed = true;
    }

    print("Izin notifikasi diberikan: $isAllowed");
    return isAllowed;
  }

  NotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel_id_01',
      'Pengingat Harian NutriBalance',
      channelDescription: 'Pengingat harian untuk mencatat asupan makanan.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    return const NotificationDetails(
      android: androidDetails,
    );
  }

  Future<void> scheduleDailyReminders() async {
    try {
      await _plugin.zonedSchedule(
        0,
        'Jangan Lupa Catat Makananmu! 🍎',
        'Buka NutriBalance untuk mencatat progres harianmu.',
        _nextInstanceOfTime(19, 0),
        _notificationDetails(),
        androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle, // Mode Android
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
        DateTimeComponents.time,
        payload: 'daily_reminder_tap',
      );
      print("Pengingat harian berhasil dijadwalkan pukul 19:00.");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

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
      if (scheduledTZTime.isBefore(tz.TZDateTime.now(tz.local))) {
        print(
            "Waktu penjadwalan $title (ID: $id) sudah lewat. Notifikasi dilewati.");
        return;
      }

      await _plugin.zonedSchedule(
        id,
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

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
    print("Semua notifikasi dibatalkan.");
  }

  Future<void> cancelNotificationById(int id) async {
    await _plugin.cancel(id);
    print("Notifikasi dengan ID $id dibatalkan.");
  }

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