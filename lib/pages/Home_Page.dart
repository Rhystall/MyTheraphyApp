import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/controllers/profile_controller.dart';
import 'package:my_theraphy/pages/profile_page.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';
import 'package:my_theraphy/widgets/bottom_navigation_bar.dart';
import 'package:my_theraphy/widgets/date_list.dart';

class HomePage extends StatelessWidget {
  final ObatController obatController = Get.find<ObatController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Obx(() {
              final imagePath = profileController.profileImagePath.value;
              return GestureDetector(
                onTap: () => Get.to(() => ProfilePage()),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: ColorCollections.primaryGray,
                  backgroundImage:
                      imagePath.isNotEmpty ? FileImage(File(imagePath)) : null,
                  child: imagePath.isEmpty
                      ? const Icon(Icons.person, color: Colors.black)
                      : null,
                ),
              );
            }),
            const SizedBox(width: 10),
            Obx(() {
              final userName = profileController.userName.value;
              return Text(
                "Hi, ${userName.isNotEmpty ? userName : 'User'}",
                style: TypographyCollection.h1,
              );
            }),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          DateSelector(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Obat Hari Ini', style: TypographyCollection.h1),
          ),
          // List Obat
          Expanded(
            child: Obx(() {
              final obatHariIni = obatController.obatHariIni;

              if (obatHariIni.isEmpty) {
                return Center(
                  child: Text(
                    "Belum ada obat",
                    style: TypographyCollection.h2,
                  ),
                );
              }

              return ListView.builder(
                itemCount: obatHariIni.length,
                itemBuilder: (context, index) {
                  final obat = obatHariIni[index];

                  return Dismissible(
                    key: Key(
                        '${obat.nama}-${obat.tanggalMulai.toIso8601String()}'),
                    background: Container(
                      color: ColorCollections.primaryDarkBlue,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.check,
                          color: ColorCollections.primaryGray),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      final selectedDate =
                          Get.find<DateSelectorController>().selectedDate.value;

                      obatController.deleteObatHariIni(obat, selectedDate);

                      if (obat.tanggalKonsumsi.isEmpty) {
                        obatController.deleteObat(obat);
                      } else {
                        obatController.allObat.refresh(); // Tambahkan refresh
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${obat.nama} selesai diminum."),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.medical_services_outlined,
                            color: Colors.black),
                      ),
                      title: Text(obat.nama),
                      subtitle: Text(
                          "${obat.jumlah} pill - ${obat.waktu.join(", ")}"),
                      trailing: obat.isAlarm
                          ? const Icon(Icons.alarm_on, color: Colors.green)
                          : const Icon(Icons.alarm_off, color: Colors.grey),
                    ),
                  );
                },
              );
            }),
          ),

          CustomBottomNavigationBar(),
        ],
      ),
    );
  }
}
