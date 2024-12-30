import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestExactAlarmPermission() async {
  if (Platform.isAndroid) {
    final int sdkInt = int.parse(
        (await Process.run('getprop', ['ro.build.version.sdk'])).stdout.trim());
    if (sdkInt >= 31) {
      try {
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );
        await intent.launch();
      } catch (e) {
        print("Gagal meminta izin exact alarm: $e");
      }
    }
  }
}

Future<bool> requestAlarmPermission() async {
  try {
    if (Platform.isAndroid) {
      final status = await Permission.systemAlertWindow.status;
      if (status.isGranted) {
        return true;
      }

      // Meminta izin jika belum diberikan
      final result = await Permission.systemAlertWindow.request();
      return result.isGranted;
    }
  } catch (e) {
    print("Error saat meminta izin alarm: $e");
    return false;
  }
  return false;
}
