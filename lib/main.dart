import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/controllers/profile_controller.dart';
import 'package:my_theraphy/helper/notification_helper.dart'; // Import NotificationHelper
import 'package:my_theraphy/pages/add_pills.dart';
import 'package:my_theraphy/pages/add_schedule.dart';
import 'package:my_theraphy/pages/home_page.dart';
import 'package:my_theraphy/pages/welcome_page.dart'; // Import WelcomePage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz; // Import timezone data
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Inisialisasi timezone
  await NotificationHelper.initialize(); // Inisialisasi notifikasi
  await AndroidAlarmManager.initialize(); // Inisialisasi alarm manager

  // Periksa izin notifikasi dan exact alarm
  await checkAndRequestNotificationPermission();
  await requestExactAlarmPermission();

  // Inisialisasi kontroler menggunakan Get
  Get.put(ProfileController());
  Get.put(DateSelectorController());
  Get.put(ObatController());

  // Tentukan apakah ini adalah pertama kali aplikasi dijalankan
  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('isFirstRun') ?? true;

  runApp(MyApp(isFirstRun: isFirstRun));
}

/// Fungsi untuk memeriksa dan meminta izin notifikasi
Future<void> checkAndRequestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied) {
    // Meminta izin jika sebelumnya ditolak
    final result = await Permission.notification.request();

    if (result.isGranted) {
      print("Izin notifikasi diberikan.");
    } else {
      print("Izin notifikasi ditolak.");
    }
  } else if (status.isGranted) {
    print("Izin notifikasi sudah diberikan.");
  } else if (status.isPermanentlyDenied) {
    print("Izin notifikasi permanen ditolak.");
    // Anda dapat mengarahkan pengguna ke pengaturan aplikasi jika diperlukan
    await openAppSettings();
  }
}

/// Fungsi untuk meminta izin SCHEDULE_EXACT_ALARM (Android 12+)
Future<void> requestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    final result = await Permission.scheduleExactAlarm.request();
    if (result.isGranted) {
      print("Izin exact alarm diberikan.");
    } else {
      print("Izin exact alarm ditolak.");
    }
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  const MyApp({super.key, required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyTheraphy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isFirstRun
          ? '/welcome'
          : '/home', // Tampilkan WelcomePage jika pertama kali
      getPages: [
        GetPage(name: '/welcome', page: () => const WelcomePage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(
          name: '/add_pills',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return AddPillsPage(
              mode: args['mode'],
              existingObat: args['existingObat'],
            );
          },
        ),
        GetPage(name: '/add_schedule', page: () => AddSchedulePage()),
      ],
    );
  }
}
