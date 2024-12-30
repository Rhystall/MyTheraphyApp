import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/obat_controller.dart';
import 'package:my_theraphy/styles/typography_collection.dart';
import 'package:my_theraphy/widgets/button_selesai.dart';
import 'package:my_theraphy/widgets/calendar.dart';
import 'package:my_theraphy/helper/alarmHelper.dart';
import 'package:permission_handler/permission_handler.dart';

class AddSchedulePage extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  AddSchedulePage({this.initialStartDate, this.initialEndDate});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final ObatController obatController = Get.find<ObatController>();

  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  List<TimeOfDay> waktuAlarms = [];
  bool useAlarm = false;

  @override
  void initState() {
    super.initState();
    tanggalMulai = widget.initialStartDate;
    tanggalBerakhir = widget.initialEndDate;
  }

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

  Future<void> _addAlarmTime() async {
    if (!useAlarm) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        waktuAlarms.add(pickedTime);
      });
    }
  }

  Future<void> _requestAlarmPermission() async {
    if (!await Permission.scheduleExactAlarm.isGranted) {
      Get.snackbar(
        "Izin Diperlukan",
        "Aplikasi memerlukan izin untuk menjadwalkan alarm presisi.",
        snackPosition: SnackPosition.BOTTOM,
      );

      if (await Permission.scheduleExactAlarm.request().isDenied) {
        Get.snackbar(
          "Izin Ditolak",
          "Silakan aktifkan izin alarm presisi di pengaturan.",
          snackPosition: SnackPosition.BOTTOM,
        );
        openAppSettings();
      }
    }
  }

  void _scheduleAlarms() async {
    if (!useAlarm) return;

    // Periksa izin sebelum menjadwalkan alarm
    if (!await Permission.scheduleExactAlarm.isGranted) {
      await _requestAlarmPermission();
      if (!await Permission.scheduleExactAlarm.isGranted) {
        return;
      }
    }

    if (tanggalMulai == null || tanggalBerakhir == null) {
      Get.snackbar(
        "Error",
        "Harap pilih tanggal mulai dan berakhir.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    DateTime currentDate = tanggalMulai!;
    int alarmId = 0;

    while (!currentDate.isAfter(tanggalBerakhir!)) {
      for (var time in waktuAlarms) {
        DateTime alarmTime = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          time.hour,
          time.minute,
        );

        if (alarmTime.isBefore(DateTime.now())) continue;

        await AlarmHelper.scheduleAlarm(
          id: alarmId++,
          dateTime: alarmTime,
          message: "Waktunya minum obat!",
        );

        print(
            "Alarm dijadwalkan pada ${alarmTime.toIso8601String()} dengan ID: $alarmId");
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tanggal & Waktu', style: TypographyCollection.h1),
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
            const SizedBox(height: 10),

            // Toggle Alarm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gunakan Alarm', style: TypographyCollection.h1),
                Switch(
                  value: useAlarm,
                  onChanged: (value) {
                    setState(() {
                      useAlarm = value;
                      if (!useAlarm) {
                        waktuAlarms.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Waktu Alarm
            if (useAlarm)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Waktu Alarm', style: TypographyCollection.h1),
                  const SizedBox(height: 10),
                  ...waktuAlarms.map((time) => ListTile(
                        title: Text(
                          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                          style: TypographyCollection.sh1,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              waktuAlarms.remove(time);
                            });
                          },
                        ),
                      )),
                  TextButton(
                    onPressed: _addAlarmTime,
                    child: Text("Tambah Waktu Alarm"),
                  ),
                ],
              ),
            const Spacer(),

            // Tombol Selesai
            Center(
              child: ButtonSelesai(
                onPressed: () {
                  if (tanggalMulai == null || tanggalBerakhir == null) {
                    Get.snackbar(
                      "Error",
                      "Harap pilih tanggal mulai dan berakhir.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  if (tanggalMulai!.isAfter(tanggalBerakhir!)) {
                    Get.snackbar(
                      "Error",
                      "Tanggal mulai tidak boleh setelah tanggal berakhir.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  print("Mengirim data: $tanggalMulai hingga $tanggalBerakhir");
                  Get.back(result: {
                    'startDate': tanggalMulai,
                    'endDate': tanggalBerakhir,
                    'useAlarm': useAlarm,
                    'waktuAlarm': waktuAlarms
                        .map((time) =>
                            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}")
                        .toList(),
                  });
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
