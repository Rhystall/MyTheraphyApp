import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/pages/add_pills.dart';
import 'package:my_theraphy/styles/typography_collection.dart';
import 'package:my_theraphy/widgets/bottom_navigation_bar.dart';

class MyPillsPage extends StatelessWidget {
  final ObatController obatController = Get.find<ObatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Pills'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final semuaObat = obatController.allObat;

              if (semuaObat.isEmpty) {
                return Center(
                  child: Text(
                    "Tidak ada obat",
                    style: TypographyCollection.h2,
                  ),
                );
              }

              return ListView.builder(
                itemCount: semuaObat.length,
                itemBuilder: (context, index) {
                  final obat = semuaObat[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.medication, color: Colors.black),
                    ),
                    title: Text(obat.nama),
                    subtitle: Text(
                      "Tanggal: ${obat.tanggalMulai.day}-${obat.tanggalMulai.month}-${obat.tanggalMulai.year} "
                      "s/d ${obat.tanggalAkhir.day}-${obat.tanggalAkhir.month}-${obat.tanggalAkhir.year}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Navigasi ke AddPillsPage dengan mode 'update' dan data existingObat
                            Get.to(() => AddPillsPage(
                                  mode: 'update',
                                  existingObat:
                                      obat, // Data obat yang akan di-update
                                ));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: Text("Hapus Obat"),
                                content: Text(
                                  "Apakah Anda yakin ingin menghapus obat ${obat.nama} dari seluruh tanggal?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(), // Tutup dialog
                                    child: Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      obatController.deleteObat(obat);
                                      Get.back(); // Tutup dialog
                                      Get.snackbar(
                                        "Sukses",
                                        "Obat ${obat.nama} telah dihapus",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    },
                                    child: Text("Hapus"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
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
