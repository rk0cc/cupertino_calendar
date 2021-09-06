import 'dart:collection' show HashSet;
import 'package:quiver/core.dart' show hash2;

class YearMonth implements Comparable<YearMonth> {
  final int year;
  final int month;

  const YearMonth(this.year, this.month) : assert(month >= 1 && month <= 12);

  /// Inspect [DateTime] object and convert back to [YearMonth]
  factory YearMonth.dateTime(DateTime dateTime) =>
      YearMonth(dateTime.year, dateTime.month);

  /// Get current [year] and [month] from [DateTime.now]
  factory YearMonth.now() {
    DateTime n = DateTime.now();
    return YearMonth(n.year, n.month);
  }

  /// Get first day of [YearMonth] and convert back to [YearMonth]
  DateTime get firstDay => DateTime(year, month, 1);

  /// Get last day of [YearMonth] and convert back to [YearMonth]
  DateTime get lastDay => DateTime(year, month + 1, 0);

  /// Generate a [Set] of [DateTime] which is from [YearMonth]
  Set<DateTime> get allDaysInMonth {
    Set<DateTime> aD = HashSet();
    for (int d = firstDay.day; d <= lastDay.day; d++) {
      aD.add(DateTime(year, month, d));
    }
    return aD;
  }

  /// Check today is contains in this month from [YearMonth.now]
  bool get todayInThisMonth => this == YearMonth.now();

  bool _checkCompreObject(Object compare) => compare is YearMonth;

  /// Compare [YearMonth] is the same value of [year] and [month]
  @override
  bool operator ==(Object compare) =>
      // ignore: test_types_in_equals
      _checkCompreObject(compare) && compareTo(compare as YearMonth) == 0;

  bool operator >(Object compare) =>
      _checkCompreObject(compare) && compareTo(compare as YearMonth) > 0;

  bool operator >=(Object compare) =>
      _checkCompreObject(compare) && compareTo(compare as YearMonth) >= 0;

  bool operator <(Object compare) =>
      _checkCompreObject(compare) && compareTo(compare as YearMonth) < 0;

  bool operator <=(Object compare) =>
      _checkCompreObject(compare) && compareTo(compare as YearMonth) <= 0;

  @override
  int get hashCode => hash2(year.hashCode, month.hashCode);

  @override
  int compareTo(YearMonth other) =>
      ((other.year - this.year) * 12) + (other.month - this.month);
}
