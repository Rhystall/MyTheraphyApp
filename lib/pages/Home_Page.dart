import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';
import 'package:my_theraphy/widgets/bottom_navigation_bar.dart';
import 'package:my_theraphy/widgets/date_list.dart';

class HomePage extends StatelessWidget {
  final ObatController obatController =
      Get.find(); // Ambil instance ObatController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: ColorCollections.primaryGray,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                Text(
                  "Hi, ",
                  style: TypographyCollection.sh1,
                ),
                Text(
                  "Zaki",
                  style: TypographyCollection.h1,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
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
              final selectedDate =
                  Get.find<DateSelectorController>().selectedDate.value;

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
                        '${obat.nama}-${selectedDate.toIso8601String()}'), // Gunakan kombinasi nama dan tanggal untuk key unik
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

                      // Coba hapus berdasarkan tanggal
                      obatController.deleteObatHariIni(obat, selectedDate);

                      // Hapus obat sepenuhnya jika `tanggalKonsumsi` kosong
                      if (obat.tanggalKonsumsi.isEmpty) {
                        obatController.deleteObat(obat);
                      } else {
                        obatController.allObat.refresh();
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${obat.nama} selesai diminum.",
                          ),
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
                        "${obat.jumlah} pill - ${obat.waktu.join(", ")}",
                      ),
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
