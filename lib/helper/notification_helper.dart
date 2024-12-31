import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print("Notifikasi berhasil diinisialisasi.");
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      print(
          "Menjadwalkan notifikasi: ID=$id, Title=$title, Body=$body, ScheduledTime=$scheduledTime");

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print("Notifikasi berhasil dijadwalkan untuk ID=$id pada $scheduledTime");
    } catch (e) {
      print("Gagal menjadwalkan notifikasi: ID=$id, Error=$e");
    }
  }

  /// Batalkan notifikasi berdasarkan ID
  static Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      print("Notifikasi dengan ID $id dibatalkan.");
    } catch (e) {
      print("Gagal membatalkan notifikasi: ID=$id, Error=$e");
    }
  }

  /// Batalkan semua notifikasi
  static Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      print("Semua notifikasi dibatalkan.");
    } catch (e) {
      print("Gagal membatalkan semua notifikasi: Error=$e");
    }
  }
}
