import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:my_theraphy/controllers/date_controller.dart';
import 'package:my_theraphy/styles/typography_collection.dart';

class ScheduleCalendar extends StatelessWidget {
  final DateSelectorController dateController =
      Get.find<DateSelectorController>(); // Ambil instance controller
  final Function(DateTime)
      onDateSelected; // Callback untuk mengembalikan tanggal

  ScheduleCalendar({required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      DateTime selectedDate = dateController.selectedDate.value;
      DateTime focusedDate = selectedDate;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple[900], // Background kalender
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            // Header Kalender Kustom
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      dateController.onDateSelected(
                        DateTime(
                          focusedDate.year,
                          focusedDate.month - 1,
                        ),
                      );
                    },
                  ),
                  Text(
                    DateFormat.yMMM().format(focusedDate),
                    style: TypographyCollection.h1.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      dateController.onDateSelected(
                        DateTime(
                          focusedDate.year,
                          focusedDate.month + 1,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Kalender
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: focusedDate,
              selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                dateController.onDateSelected(selectedDay);
                onDateSelected(selectedDay);
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue, // Warna tanggal yang dipilih
                  shape: BoxShape.circle,
                ),
                todayDecoration: const BoxDecoration(
                  color: Colors.orange, // Warna tanggal hari ini
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TypographyCollection.sh1.copyWith(
                  color: Colors.white, // Warna default tanggal
                ),
                weekendTextStyle: TypographyCollection.sh1.copyWith(
                  color: Colors.red, // Warna akhir pekan
                ),
                outsideTextStyle: TypographyCollection.sh1.copyWith(
                  color: Colors.grey[500], // Warna tanggal di luar bulan
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TypographyCollection.sh1.copyWith(
                  color: Colors.white, // Warna nama hari
                ),
                weekendStyle: TypographyCollection.sh1.copyWith(
                  color: Colors.red, // Warna nama akhir pekan
                ),
              ),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  final text = DateFormat.E().format(day);
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0), // Tambahkan jarak ke bawah
                    child: Center(
                      child: Text(
                        text,
                        style: TypographyCollection.sh1.copyWith(
                          color: day.weekday == DateTime.sunday
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              headerVisible: false, // Header bawaan dihilangkan
            ),
          ],
        ),
      );
    });
  }
}
