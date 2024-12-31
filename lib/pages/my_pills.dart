import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/pages/add_pills.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';
import 'package:my_theraphy/widgets/bottom_navigation_bar.dart';

class MyPillsPage extends StatefulWidget {
  const MyPillsPage({super.key});

  @override
  _MyPillsPageState createState() => _MyPillsPageState();
}

class _MyPillsPageState extends State<MyPillsPage> {
  final ObatController obatController = Get.find<ObatController>();
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Daftar Obat',
          style: TypographyCollection.h1,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) => searchQuery.value = value,
              decoration: InputDecoration(
                hintText: "Cari nama obat...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: ColorCollections.accentGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final semuaObat = obatController.allObat;
              final filteredObat = semuaObat
                  .where((obat) => obat.nama
                      .toLowerCase()
                      .contains(searchQuery.value.toLowerCase()))
                  .toList();

              if (filteredObat.isEmpty) {
                return Center(
                  child: Text(
                    searchQuery.isEmpty
                        ? "Tidak ada obat"
                        : "Tidak ditemukan obat dengan nama \"${searchQuery.value}\"",
                    style: TypographyCollection.h2,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredObat.length,
                itemBuilder: (context, index) {
                  final obat = filteredObat[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: ColorCollections.accentGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Detail Obat
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Obat
                              Text(
                                obat.nama,
                                style: TypographyCollection.h1.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Jumlah dan Dosis
                              Text(
                                "${obat.jumlah} pill, ${obat.dosis} kali per hari",
                                style: TypographyCollection.sh2.copyWith(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Alarm atau Tanggal Awal-Akhir
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: obat.isAlarm
                                        ? Colors.green
                                        : Colors.black,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    obat.isAlarm &&
                                            obat.waktuAlarm != null &&
                                            obat.waktuAlarm!.isNotEmpty
                                        ? obat.waktuAlarm!.join(", ")
                                        : "Tidak ada Alarm",
                                    style: TypographyCollection.sh1.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Tanggal Awal-Akhir
                              Text(
                                "Tanggal: ${obat.tanggalMulai.day}-${obat.tanggalMulai.month}-${obat.tanggalMulai.year} s/d ${obat.tanggalAkhir.day}-${obat.tanggalAkhir.month}-${obat.tanggalAkhir.year}",
                                style: TypographyCollection.sh2.copyWith(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tombol Edit dan Hapus
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Get.to(() => AddPillsPage(
                                      mode: 'update',
                                      existingObat: obat,
                                    ));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text("Hapus Obat"),
                                    content: Text(
                                      "Apakah Anda yakin ingin menghapus obat ${obat.nama} dari seluruh tanggal?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text("Batal"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          obatController.deleteObat(obat);
                                          Get.back();
                                          Get.snackbar(
                                            "Sukses",
                                            "Obat ${obat.nama} telah dihapus",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        },
                                        child: const Text("Hapus"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
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
