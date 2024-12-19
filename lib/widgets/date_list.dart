import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';

class DateSelector extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = List.generate(
      controller.daysInMonth(controller.selectedDate.value),
      (index) => DateTime(
        controller.selectedDate.value.year,
        controller.selectedDate.value.month,
        index + 1,
      ),
    );

    String getMonthName(int month) {
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

    return Obx(() {
      DateTime selectedDate = controller.selectedDate.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bulan dan Tahun
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  "${getMonthName(selectedDate.month)}",
                  style: TypographyCollection.h1,
                ),
                const SizedBox(width: 5),
                Text(
                  "${selectedDate.year}",
                  style: TypographyCollection.sh1,
                ),
                const Icon(Icons.keyboard_arrow_down),
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
                    controller.selectedDate(dates[index]); // Update tanggal
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
