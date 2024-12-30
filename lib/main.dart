import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/controllers/profile_controller.dart';
import 'package:my_theraphy/helper/alarmHelper.dart';
import 'package:my_theraphy/helper/notification_helper.dart'; // Import NotificationHelper
import 'package:my_theraphy/pages/add_pills.dart';
import 'package:my_theraphy/pages/add_schedule.dart';
import 'package:my_theraphy/pages/home_page.dart';
import 'package:my_theraphy/pages/welcome_page.dart'; // Import WelcomePage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz; // Import timezone data

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Inisialisasi timezone
  await NotificationHelper.initialize(); // Inisialisasi notifikasi
  await AndroidAlarmManager.initialize(); // Inisialisasi alarm manager

  // Inisialisasi kontroler menggunakan Get
  Get.put(ProfileController());
  Get.put(DateSelectorController());
  Get.put(ObatController());

  // Tentukan apakah ini adalah pertama kali aplikasi dijalankan
  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('isFirstRun') ?? true;

  if (isFirstRun) {
    await prefs.setBool('isFirstRun', false);
  }

  runApp(MyApp(isFirstRun: isFirstRun));
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
        GetPage(name: '/welcome', page: () => WelcomePage()),
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
