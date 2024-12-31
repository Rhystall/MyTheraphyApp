import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  final DateSelectorController controller = Get.find(); // Ambil controller
  late ScrollController _scrollController; // ScrollController untuk ListView

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Scroll otomatis ke tanggal hari ini setelah widget dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  // Scroll otomatis ke tanggal yang dipilih
  void _scrollToSelectedDate() {
    int index = controller.selectedDate.value.day - 1; // Index tanggal
    double offset = index * 85.0; // Perhitungan offset (80 lebar item + margin)
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showMonthYearPickerDialog() {
    // Gunakan Obx untuk mengamati perubahan bulan dan tahun
    int selectedYear = controller.selectedDate.value.year;
    int selectedMonth = controller.selectedDate.value.month;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:
                  Text("Pilih Bulan & Tahun", style: TypographyCollection.h1),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown untuk bulan
                  DropdownButton<int>(
                    value: selectedMonth,
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(
                          _getMonthName(index + 1),
                          style: TypographyCollection.sh1,
                        ),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMonth = value; // Perbarui bulan yang dipilih
                        });
                      }
                    },
                  ),
                  // Dropdown untuk tahun
                  DropdownButton<int>(
                    value: selectedYear,
                    items: List.generate(50, (index) {
                      int year = DateTime.now().year - 25 + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(
                          year.toString(),
                          style: TypographyCollection.sh1,
                        ),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedYear = value; // Perbarui tahun yang dipilih
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Batal", style: TypographyCollection.sh2),
                ),
                TextButton(
                  onPressed: () {
                    // Perbarui tanggal di controller
                    controller.onDateSelected(
                      DateTime(selectedYear, selectedMonth, 1),
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Pilih", style: TypographyCollection.h1),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      DateTime selectedDate = controller.selectedDate.value;

      List<DateTime> dates = List.generate(
        controller.daysInMonth(selectedDate),
        (index) => DateTime(selectedDate.year, selectedDate.month, index + 1),
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bulan dan Tahun
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  _getMonthName(selectedDate.month),
                  style: TypographyCollection.h1,
                ),
                const SizedBox(width: 5),
                Text(
                  "${selectedDate.year}",
                  style: TypographyCollection.sh1,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: _showMonthYearPickerDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // List Tanggal
          SizedBox(
            height: 100,
            child: ListView.builder(
              controller: _scrollController, // Tambahkan ScrollController
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              itemBuilder: (context, index) {
                bool isSelected = dates[index].day == selectedDate.day;
                return GestureDetector(
                  onTap: () {
                    controller.onDateSelected(dates[index]); // Update tanggal
                    _scrollToSelectedDate(); // Scroll ke tanggal yang dipilih
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorCollections.primaryDarkBlue
                          : ColorCollections.primaryGray,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dates[index].day.toString(),
                          style: TypographyCollection.h1.copyWith(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          [
                            'Sen',
                            'Sel',
                            'Rab',
                            'Kam',
                            'Jum',
                            'Sab',
                            'Min'
                          ][dates[index].weekday - 1],
                          style: TypographyCollection.sh2.copyWith(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
