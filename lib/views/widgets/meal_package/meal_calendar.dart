import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Widget Kalender khusus untuk Meal Package Screen
class MealCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime)? onPageChanged; // Opsional
  final Function(CalendarFormat)? onFormatChanged; // Opsional, jika format bisa diubah

  const MealCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    this.onPageChanged,
    this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return TableCalendar(
      locale: 'id_ID', // Gunakan locale Indonesia
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      calendarFormat: calendarFormat,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected, // Gunakan callback dari parameter
      onPageChanged: onPageChanged, // Gunakan callback dari parameter
      onFormatChanged: onFormatChanged, // Gunakan callback dari parameter

      // Styling Header
      headerStyle: HeaderStyle(
        titleCentered: true,
        // Format judul bulan dan tahun
        titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
        titleTextStyle: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
        formatButtonVisible: false, // Sembunyikan tombol format (Week/Month)
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.grey),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.grey),
      ),

      // Styling Nama Hari (Sen, Sel, ...)
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.black54), // Warna hari weekend
        weekdayStyle: TextStyle(color: Colors.black54), // Warna hari biasa
      ),

      // Styling Tanggal
      calendarStyle: CalendarStyle(
        // Dekorasi hari ini
        todayDecoration: BoxDecoration(
          color: Colors.grey.shade200, // Background abu-abu
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(color: Colors.black), // Teks hitam

        // Dekorasi hari yang dipilih
        selectedDecoration: BoxDecoration(
          color: primaryColor, // Background warna primer
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Teks putih tebal

        // Sembunyikan tanggal di luar bulan ini
        outsideDaysVisible: false,

        // Styling weekend
        weekendTextStyle: TextStyle(color: Colors.red.shade400), // Contoh: warna merah untuk weekend
      ),
      // Builder untuk kustomisasi lebih lanjut (opsional)
      // calendarBuilders: CalendarBuilders(...),
    );
  }
}