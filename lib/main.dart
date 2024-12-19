import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/pages/add_pills.dart';
import 'package:my_theraphy/pages/add_schedule.dart';
import 'package:my_theraphy/pages/home_page.dart';

void main() {
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
