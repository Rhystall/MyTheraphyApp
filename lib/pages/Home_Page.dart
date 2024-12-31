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
          const SizedBox(
            height: 16,
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        obatController.allObat.refresh();
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${obat.nama} selesai diminum."),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorCollections.accentGray,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.medical_services_outlined,
                                color: Colors.black),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${obat.jumlah} pill, ${obat.dosis} kali per hari",
                                  style: TypographyCollection.sh2.copyWith(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  obat.nama,
                                  style: TypographyCollection.h1.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: obat.isAlarm
                                          ? Colors.green
                                          : Colors.black,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      obat.isAlarm &&
                                              obat.waktuAlarm != null &&
                                              obat.waktuAlarm!.isNotEmpty
                                          ? obat.waktuAlarm!.join(", ")
                                          : "${obat.tanggalMulai.day}-${obat.tanggalMulai.month}-${obat.tanggalMulai.year}",
                                      style: TypographyCollection.sh1.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          const CustomBottomNavigationBar(),
        ],
      ),
    );
  }
}
