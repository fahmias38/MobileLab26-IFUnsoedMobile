class DateFormatter {
  DateFormatter._();

  static const List<String> _days = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Mengubah string tanggal ISO ("2026-11-25") menjadi label mudah dibaca.
  static String formatForecastDate(String isoDate, {int index = -1}) {
    if (index == 0) return 'Hari Ini';
    if (index == 1) return 'Besok';

    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return isoDate;

    final dayName = _days[parsed.weekday - 1];
    final monthName = _months[parsed.month - 1];
    return '$dayName, ${parsed.day} $monthName';
  }
}
