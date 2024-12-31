import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/helper/notification_helper.dart'; // Import NotificationHelper
import '../models/obat.dart';
import '../helper/DBHelper.dart';

class ObatController extends GetxController {
  final RxList<Obat> allObat = <Obat>[].obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(null); // Tanggal Mulai
  final Rx<DateTime?> endDate = Rx<DateTime?>(null); // Tanggal Akhir
  RxString jenisObat = ''.obs;
  RxString jumlahPill = ''.obs;
  RxString dosisPerHari = ''.obs;

  // Fungsi untuk membersihkan data
  void clearData() {
    jenisObat.value = '';
    jumlahPill.value = '';
    dosisPerHari.value = '';
    startDate.value = null;
    endDate.value = null;
  }

  void updateJenisObat(String value) {
    jenisObat.value = value;
  }

  void updateJumlahPill(String value) {
    jumlahPill.value = value;
  }

  void updateDosisPerHari(String value) {
    dosisPerHari.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchObat(); // Ambil data dari database saat inisialisasi
  }

  Future<void> fetchObat() async {
    allObat.value = await DBHelper.getObatList();
    print("Data obat setelah fetch: ${allObat.map((e) => e.toJson())}");
    validateUpdatedData(); // Validasi data setelah fetch
  }

  List<Obat> get obatHariIni {
    final selectedDate = Get.find<DateSelectorController>().selectedDate.value;

    final normalizedSelectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    return allObat.where((obat) {
      return obat.tanggalKonsumsi.any((tanggalKonsumsi) {
        final normalizedTanggalKonsumsi = DateTime(
          tanggalKonsumsi.year,
          tanggalKonsumsi.month,
          tanggalKonsumsi.day,
        );
        return normalizedTanggalKonsumsi == normalizedSelectedDate;
      });
    }).toList();
  }

  Future<void> addObat(Obat obat) async {
    await DBHelper.insertObat(obat);
    fetchObat(); // Refresh data setelah insert
  }

  void deleteObatHariIni(Obat obat, DateTime selectedDate) {
    final normalizedSelectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    obat.tanggalKonsumsi.removeWhere((date) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      return normalizedDate == normalizedSelectedDate;
    });

    if (obat.tanggalKonsumsi.isEmpty) {
      allObat.remove(obat);
    }

    allObat.refresh();
  }

  Future<void> deleteObat(Obat obat) async {
    if (obat.id != null) {
      // Batalkan semua notifikasi terkait obat
      if (obat.waktuAlarm != null) {
        for (String waktuAlarm in obat.waktuAlarm!) {
          final id = generateNotificationId(obat, waktuAlarm);
          await NotificationHelper.cancelNotification(id);
        }
      }

      await DBHelper.deleteObat(obat.id!);
      allObat.remove(obat);
      allObat.refresh();
    }
  }

  void updateStartDate(DateTime? date) {
    print("Start date updated to: $date");
    startDate.value = date;
  }

  void updateEndDate(DateTime? date) {
    print("End date updated to: $date");
    endDate.value = date;
  }

  Future<void> updateObat(Obat obat) async {
    if (obat.id != null) {
      // Perbarui tanggal konsumsi berdasarkan tanggal mulai dan akhir
      List<DateTime> tanggalKonsumsiBaru = [];
      DateTime currentDate = obat.tanggalMulai;
      while (currentDate
          .isBefore(obat.tanggalAkhir.add(const Duration(days: 1)))) {
        tanggalKonsumsiBaru.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
      obat.tanggalKonsumsi = tanggalKonsumsiBaru;

      // Debugging log
      print("Mengupdate obat dengan ID: ${obat.id}");
      print(
          "Tanggal konsumsi baru: ${tanggalKonsumsiBaru.map((e) => e.toIso8601String()).toList()}");

      // Simpan ke database
      final result = await DBHelper.updateObat(obat);
      if (result > 0) {
        print("Obat berhasil diperbarui di database.");
      } else {
        print("Gagal memperbarui obat di database.");
      }

      // Refresh data setelah pembaruan
      fetchObat();
    }
  }

  void validateUpdatedData() {
    allObat.forEach((obat) {
      print("Obat ID: ${obat.id}");
      print(
          "Tanggal konsumsi: ${obat.tanggalKonsumsi.map((e) => e.toIso8601String()).toList()}");
    });
  }

  void saveNewObat(
    String nama,
    int jumlah,
    int dosis,
    List<String> waktu,
    bool isAlarm,
  ) async {
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar(
        "Error",
        "Tanggal mulai dan akhir harus diisi",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Generate tanggal konsumsi
    List<DateTime> tanggalKonsumsi = [];
    DateTime currentDate = startDate.value!;
    while (currentDate.isBefore(endDate.value!.add(const Duration(days: 1)))) {
      tanggalKonsumsi.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    print("Waktu Alarm di saveNewObat sebelum pembuatan objek: $waktu");

    // Buat objek Obat
    final newObat = Obat(
      nama: nama,
      tanggalMulai: startDate.value!,
      tanggalAkhir: endDate.value!,
      jumlah: jumlah,
      dosis: dosis,
      waktu: waktu,
      isAlarm: isAlarm,
      waktuAlarm: isAlarm ? waktu : null, // Pastikan waktuAlarm diteruskan
      tanggalKonsumsi: tanggalKonsumsi,
    );

    print("Waktu Alarm di objek Obat: ${newObat.waktuAlarm}");

    await addObat(newObat);

    // Jadwalkan alarm jika isAlarm aktif
    if (isAlarm && waktu.isNotEmpty) {
      for (String waktuAlarm in waktu) {
        final parsedTime = waktuAlarm.split(':');
        if (parsedTime.length == 2) {
          final hour = int.parse(parsedTime[0]);
          final minute = int.parse(parsedTime[1]);

          for (DateTime tanggal in tanggalKonsumsi) {
            final DateTime alarmTime = DateTime(
              tanggal.year,
              tanggal.month,
              tanggal.day,
              hour,
              minute,
            );

            await NotificationHelper.scheduleNotification(
              id: generateNotificationId(newObat, waktuAlarm),
              title: "Ingat minum obat",
              body: "Saatnya minum obat $nama",
              scheduledTime: alarmTime,
            );
          }
        }
      }
    }

    // Reset tanggal setelah menyimpan obat
    startDate.value = null;
    endDate.value = null;

    Get.snackbar(
      "Sukses",
      "$nama berhasil ditambahkan",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  int generateNotificationId(Obat obat, String waktuAlarm) {
    return obat.hashCode ^ waktuAlarm.hashCode;
  }
}
