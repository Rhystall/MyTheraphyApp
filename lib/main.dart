import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/helper/alarmHelper.dart';
import 'package:my_theraphy/helper/notification_helper.dart'; // Import NotificationHelper
import 'package:my_theraphy/pages/add_pills.dart';
import 'package:my_theraphy/pages/add_schedule.dart';
import 'package:my_theraphy/pages/home_page.dart';
import 'package:timezone/data/latest.dart' as tz; // Import timezone data

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Inisialisasi timezone
  await NotificationHelper.initialize(); // Inisialisasi notifikasi
  await AndroidAlarmManager.initialize(); // Inisialisasi alarm manager
  Get.put(DateSelectorController());
  Get.put(ObatController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyTheraphy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/add_pills', page: () => AddPillsPage()),
        GetPage(name: '/add_schedule', page: () => AddSchedulePage()),
      ],
    );
  }
}
