import 'package:get/get.dart';

class DateSelectorController extends GetxController {
  // Tanggal yang dipilih
  var selectedDate = DateTime.now().obs;

  // Memperbarui Tanggal
  void onDateSelected(DateTime date) {
    selectedDate.value = date;
  }

  // Menghitung jumlah hari dalam bulan
  int daysInMonth(DateTime date) {
    var beginningNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1)).day;
  }
}
