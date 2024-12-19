import 'package:get/get.dart';
import 'package:my_theraphy/models/obat.dart';
import 'package:my_theraphy/controllers/date_controller.dart';

class ObatController extends GetxController {
  // Data dummy untuk obat
  final RxList<Obat> allObat = <Obat>[
    Obat(
      nama: "Vitamin C",
      tanggal: DateTime(2024, 12, 20),
      jumlah: 2,
      dosis: 1,
      waktu: ["10:00 pagi"],
      isAlarm: true,
      ringtone: "Default",
    ),
    Obat(
      nama: "Paracetamol",
      tanggal: DateTime(2024, 12, 19),
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
      return obat.tanggal.year == selectedDate.year &&
          obat.tanggal.month == selectedDate.month &&
          obat.tanggal.day == selectedDate.day;
    }).toList();
  }

  // Fungsi untuk menambah atau menghapus obat
  void addObat(Obat obat) {
    allObat.add(obat);
  }

  void deleteObat(Obat obat) {
    allObat.remove(obat);
  }
}
