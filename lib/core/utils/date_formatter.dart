extension DateFormatter on DateTime {
  String formatDayMonthYear() {
    return '${day.toString().padLeft(2, '0')}.'
        '${month.toString().padLeft(2, '0')}.'
        '$year';
  }
}
