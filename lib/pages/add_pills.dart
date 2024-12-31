import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/pages/add_schedule.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';
import 'package:my_theraphy/widgets/button_selesai.dart';
import '../models/obat.dart';

class AddPillsPage extends StatelessWidget {
  final String mode; // 'add' atau 'update'
  final Obat?
      existingObat; // Data obat yang akan di-update (null jika mode 'add')

  AddPillsPage({required this.mode, this.existingObat});

  final ObatController obatController = Get.find<ObatController>();
  final TextEditingController jenisObatController = TextEditingController();
  final TextEditingController jumlahPillController = TextEditingController();
  final TextEditingController dosisPerHariController = TextEditingController();
  bool isAlarm = false;
  List<String> waktuAlarm = [];

  @override
  Widget build(BuildContext context) {
    // Inisialisasi data jika mode adalah 'update'
    if (mode == 'update' && existingObat != null) {
      print("Sebelum update: ${existingObat!.toJson()}");

      jenisObatController.text = existingObat!.nama;
      jumlahPillController.text = existingObat!.jumlah.toString();
      dosisPerHariController.text = existingObat!.dosis.toString();
      isAlarm = existingObat!.isAlarm;
      waktuAlarm = existingObat!.waktuAlarm ?? [];
      obatController.updateStartDate(existingObat!.tanggalMulai);
      obatController.updateEndDate(existingObat!.tanggalAkhir);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          mode == 'add' ? 'Tambah Obat' : 'Update Obat',
          style: TypographyCollection.h1,
        ),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Jenis Obat
            Text('Jenis Obat', style: TypographyCollection.h1),
            const SizedBox(height: 10),
            TextField(
              controller: jenisObatController,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.medication, color: Colors.black),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                filled: true,
                fillColor: ColorCollections.accentGray,
              ),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            // Dosis
            Text('Dosis', style: TypographyCollection.h1),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: jumlahPillController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: 'Pill',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      filled: true,
                      fillColor: ColorCollections.accentGray,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: dosisPerHariController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: 'Per Hari',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      filled: true,
                      fillColor: ColorCollections.accentGray,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tanggal & Waktu
            Text('Tanggal & Waktu', style: TypographyCollection.h1),
            Obx(() {
              final startDate = obatController.startDate.value;
              final endDate = obatController.endDate.value;
              return Column(
                children: [
                  if (startDate != null && endDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Dari ${startDate.day}-${startDate.month}-${startDate.year} "
                        "sampai ${endDate.day}-${endDate.month}-${endDate.year}",
                        style: TypographyCollection.sh1,
                      ),
                    ),
                  if (isAlarm && waktuAlarm.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: waktuAlarm.map((time) {
                          return Text(
                            "Alarm: $time",
                            style: TypographyCollection.sh1,
                          );
                        }).toList(),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    width: 150,
                    decoration: BoxDecoration(
                      color: ColorCollections.accentGray,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Get.to(() => AddSchedulePage(
                              initialStartDate: obatController.startDate.value,
                              initialEndDate: obatController.endDate.value,
                            ));

                        if (result != null) {
                          print("Data diterima dari AddSchedulePage: $result");
                          obatController.updateStartDate(result['startDate']);
                          obatController.updateEndDate(result['endDate']);
                          isAlarm = result['useAlarm'] ?? false;
                          waktuAlarm = result['waktuAlarm'] ?? [];
                          print("Waktu Alarm setelah update: $waktuAlarm");
                        } else {
                          print("Tidak ada data diterima dari AddSchedulePage");
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add,
                              color: ColorCollections.accentDarkBlack),
                          const SizedBox(width: 10),
                          Text(
                            mode == 'add' ? 'Tambah' : 'Ubah',
                            style: TypographyCollection.italic,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            const Spacer(),

            // Tombol Selesai
            Center(
              child: ButtonSelesai(
                onPressed: () {
                  final jenisObat = jenisObatController.text;
                  final jumlahPill = int.tryParse(jumlahPillController.text);
                  final dosisPerHari =
                      int.tryParse(dosisPerHariController.text);

                  if (jenisObat.isEmpty ||
                      jumlahPill == null ||
                      dosisPerHari == null ||
                      obatController.startDate.value == null ||
                      obatController.endDate.value == null) {
                    Get.snackbar(
                      "Error",
                      "Harap isi semua field dan pilih tanggal mulai & akhir",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  print(
                      "Waktu Alarm yang diteruskan ke saveNewObat: $waktuAlarm");

                  if (mode == 'add') {
                    obatController.saveNewObat(
                      jenisObat,
                      jumlahPill,
                      dosisPerHari,
                      waktuAlarm,
                      isAlarm,
                    );
                  } else if (mode == 'update' && existingObat != null) {
                    existingObat!.nama = jenisObat;
                    existingObat!.jumlah = jumlahPill;
                    existingObat!.dosis = dosisPerHari;
                    existingObat!.tanggalMulai =
                        obatController.startDate.value!;
                    existingObat!.tanggalAkhir = obatController.endDate.value!;
                    existingObat!.isAlarm = isAlarm;
                    existingObat!.waktuAlarm = waktuAlarm;

                    obatController.updateObat(existingObat!);
                  }

                  obatController.clearData();
                  Get.offAllNamed('/home');
                },
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
