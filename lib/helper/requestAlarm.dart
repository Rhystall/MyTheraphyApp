import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkAndRequestAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isGranted) {
    print("Izin SCHEDULE_EXACT_ALARM diberikan.");
  } else {
    print("Meminta izin SCHEDULE_EXACT_ALARM.");
    await Permission.scheduleExactAlarm.request();
  }
}
