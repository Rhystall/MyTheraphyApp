import 'package:android_intent_plus/android_intent.dart';

class AlarmHelper {
  static void setSystemAlarm({
    required int hour,
    required int minute,
    required String message,
  }) {
    final intent = AndroidIntent(
      action: 'android.intent.action.SET_ALARM',
      arguments: {
        'android.intent.extra.alarm.HOUR': hour,
        'android.intent.extra.alarm.MINUTES': minute,
        'android.intent.extra.alarm.MESSAGE': message,
        // 'android.intent.extra.alarm.SKIP_UI': true, // Optional
      },
    );

    try {
      print("Mengatur alarm: $hour:$minute - $message");
      intent.launch();
    } catch (e) {
      print("Gagal meluncurkan intent: $e");
    }
  }
}
