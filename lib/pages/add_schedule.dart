import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';
import 'package:my_theraphy/widgets/button_selesai.dart';
import 'package:my_theraphy/widgets/calendar.dart';

class AddSchedulePage extends StatefulWidget {
  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final ObatController obatController = Get.find<ObatController>();

  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;

  void _showCalendarDialog(String tipeTanggal) async {
    DateTime? selectedDate = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Pilih Tanggal", style: TypographyCollection.h1),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ScheduleCalendar(
              onDateSelected: (selectedDate) {
                Navigator.of(context).pop(selectedDate);
              },
            ),
          ),
        ),
      ),
    );

    if (selectedDate != null) {
      setState(() {
        if (tipeTanggal == 'mulai') {
          tanggalMulai = selectedDate;
        } else if (tipeTanggal == 'berakhir') {
          tanggalBerakhir = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Tanggal & Waktu',
          style: TypographyCollection.h1,
        ),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal Mulai
            Text('Tanggal Mulai', style: TypographyCollection.h1),
            ListTile(
              title: Text(
                tanggalMulai != null
                    ? "${tanggalMulai!.day}-${tanggalMulai!.month}-${tanggalMulai!.year}"
                    : 'Pilih Tanggal',
                style: TypographyCollection.sh1,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _showCalendarDialog('mulai'),
            ),
            const SizedBox(height: 10),

            // Tanggal Berakhir
            Text('Tanggal Berakhir', style: TypographyCollection.h1),
            ListTile(
              title: Text(
                tanggalBerakhir != null
                    ? "${tanggalBerakhir!.day}-${tanggalBerakhir!.month}-${tanggalBerakhir!.year}"
                    : 'Pilih Tanggal',
                style: TypographyCollection.sh1,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _showCalendarDialog('berakhir'),
            ),
            // // Alarm
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Alarm', style: TypographyCollection.h1),
            //     Switch(
            //       value: true, // Default alarm aktif
            //       onChanged: (bool value) {
            //         // Logika switch alarm
            //       },
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 10),

            // // Ringtone
            // ListTile(
            //   title: const Text('Ringtone'),
            //   trailing: const Icon(Icons.keyboard_arrow_right),
            //   onTap: () {
            //     // Logika pemilihan ringtone
            //   },
            // ),
            const Spacer(),
            // Tombol Selesai
            Center(
              child: ButtonSelesai(
                onPressed: () {
                  if (tanggalMulai == null || tanggalBerakhir == null) {
                    Get.snackbar(
                      "Error",
                      "Harap pilih tanggal mulai dan berakhir",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  // Simpan tanggal ke controller
                  obatController.updateStartDate(tanggalMulai);
                  obatController.updateEndDate(tanggalBerakhir);

                  // Tambahkan logging untuk memastikan
                  print("Tanggal Mulai: ${obatController.startDate.value}");
                  print("Tanggal Akhir: ${obatController.endDate.value}");

                  Get.back(); // Kembali ke AddPillsPage
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
