import 'package:get/get.dart';
import 'package:my_theraphy/models/obat.dart';
import 'package:my_theraphy/controllers/date_controller.dart';

class ObatController extends GetxController {
  final Rx<DateTime?> startDate = Rx<DateTime?>(null); // Tanggal Mulai
  final Rx<DateTime?> endDate = Rx<DateTime?>(null); // Tanggal Akhir

  // Data dummy untuk obat
  final RxList<Obat> allObat = <Obat>[
    Obat(
      nama: "Vitamin C",
      tanggalMulai: DateTime(2024, 12, 20),
      tanggalAkhir: DateTime(2024, 12, 25),
      jumlah: 2,
      dosis: 1,
      waktu: ["10:00 pagi"],
      isAlarm: true,
      ringtone: "Default",
    ),
    Obat(
      nama: "Paracetamol",
      tanggalMulai: DateTime(2024, 12, 19),
      tanggalAkhir: DateTime(2024, 12, 22),
      jumlah: 1,
      dosis: 2,
      waktu: ["08:00 pagi", "08:00 malam"],
      isAlarm: false,
    ),
  ].obs;

  // Filter obat berdasarkan tanggal yang dipilih dari DateSelectorController
  List<Obat> get obatHariIni {
    final selectedDate = Get.find<DateSelectorController>().selectedDate.value;
    return allObat.where((obat) {
      return selectedDate
              .isAfter(obat.tanggalMulai.subtract(const Duration(days: 1))) &&
          selectedDate.isBefore(obat.tanggalAkhir.add(const Duration(days: 1)));
    }).toList();
  }

  // Fungsi untuk menambah atau menghapus obat
  void addObat(Obat obat) {
    allObat.add(obat);
  }

  void deleteObat(Obat obat) {
    allObat.remove(obat);
  }

  // Perbarui tanggal mulai
  void updateStartDate(DateTime? date) {
    startDate.value = date;
  }

  // Perbarui tanggal akhir
  void updateEndDate(DateTime? date) {
    endDate.value = date;
  }

  // Buat obat baru dengan tanggal mulai dan akhir
  void saveNewObat(String nama, int jumlah, int dosis, List<String> waktu,
      {bool isAlarm = false, String ringtone = "Default"}) {
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar(
        "Error",
        "Tanggal mulai dan akhir harus diisi",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newObat = Obat(
      nama: nama,
      tanggalMulai: startDate.value!,
      tanggalAkhir: endDate.value!,
      jumlah: jumlah,
      dosis: dosis,
      waktu: waktu,
      isAlarm: isAlarm,
      ringtone: ringtone,
    );

    addObat(newObat);

    // Reset tanggal setelah menyimpan obat
    startDate.value = null;
    endDate.value = null;

    Get.snackbar(
      "Sukses",
      "$nama berhasil ditambahkan",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
