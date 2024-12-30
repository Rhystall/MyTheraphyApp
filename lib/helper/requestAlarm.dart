import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    if (await Permission.scheduleExactAlarm.isGranted) {
      print("Izin exact alarm sudah diberikan.");
      return;
    }

    final intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    try {
      await intent.launch();
      print("Meminta izin exact alarm.");
    } catch (e) {
      print("Gagal meminta izin exact alarm: $e");
    }
  }
}
