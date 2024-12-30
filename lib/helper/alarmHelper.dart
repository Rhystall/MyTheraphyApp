import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class AlarmHelper {
  /// Inisialisasi AlarmHelper
  static Future<void> initialize() async {
    try {
      await AndroidAlarmManager.initialize();
      print("Android Alarm Manager berhasil diinisialisasi");
    } catch (e) {
      print("Gagal menginisialisasi Android Alarm Manager: $e");
    }
  }

  /// Menjadwalkan alarm pada waktu tertentu
  static Future<void> scheduleAlarm({
    required int id,
    required DateTime dateTime,
    required String message,
  }) async {
    if (dateTime.isBefore(DateTime.now())) {
      print("Tidak dapat menjadwalkan alarm di masa lalu.");
      return;
    }

    try {
      await AndroidAlarmManager.oneShotAt(
        dateTime,
        id, // ID unik untuk alarm
        alarmCallback, // Gunakan fungsi global/top-level sebagai callback
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true, // Reschedule alarm setelah reboot
      );

      print("Alarm dijadwalkan pada $dateTime dengan ID: $id");
    } catch (e) {
      print("Gagal menjadwalkan alarm: $e");
    }
  }
}

/// Fungsi callback untuk alarm (Harus global/top-level)
void alarmCallback() {
  print("Alarm aktif: Waktunya minum obat!");
  // Tambahkan logika seperti notifikasi di sini jika diperlukan
}
