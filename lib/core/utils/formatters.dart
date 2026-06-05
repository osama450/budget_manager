import 'package:intl/intl.dart';

/// Western-digit number/date formatting helpers, locale-aware where it helps.
class Formatters {
  Formatters._();

  static final NumberFormat _money = NumberFormat('#,##0.##');

  static String money(num value, String symbol) =>
      '${_money.format(value)} $symbol';

  static String number(num value) => _money.format(value);

  static String percent(double ratio) => '${(ratio * 100).round()}%';

  static String dayMonth(DateTime date, String locale) =>
      DateFormat('d MMM', locale).format(date);

  static String fullDate(DateTime date, String locale) =>
      DateFormat('d MMM yyyy', locale).format(date);

  /// "2026-06" -> localized "June 2026".
  static String monthLabel(String monthId, String locale) {
    final parts = monthId.split('-');
    if (parts.length != 2) return monthId;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (y == null || m == null) return monthId;
    return DateFormat('MMMM yyyy', locale).format(DateTime(y, m));
  }
}
