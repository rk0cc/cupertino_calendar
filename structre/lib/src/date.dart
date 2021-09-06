import 'dart:collection' show LinkedHashSet, SetBase;
import 'package:quiver/core.dart' show hash2;

class YearMonth implements Comparable<YearMonth> {
  final int year;
  final int month;

  const YearMonth(this.year, this.month) : assert(month >= 1 && month <= 12);

  /// Inspect [DateTime] object and convert back to [YearMonth]
  factory YearMonth.dateTime(DateTime dateTime) =>
      YearMonth(dateTime.year, dateTime.month);

  /// Get current [year] and [month] from [DateTime.now]
  factory YearMonth.now() => YearMonth.dateTime(DateTime.now());

  /// Get first day of [YearMonth] and convert back to [YearMonth]
  DateTime get firstDay => DateTime(year, month, 1);

  /// Get last day of [YearMonth] and convert back to [YearMonth]
  DateTime get lastDay => DateTime(year, month + 1, 0);

  /// Generate a [Set] of [DateTime] which is from [YearMonth]
  Set<DateTime> get allDaysInMonth {
    Set<DateTime> aD = LinkedHashSet();
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

typedef YearMonthForEachHandler = void Function(YearMonth);

class YearMonthRange extends SetBase<YearMonth> {
  final Set<YearMonth> _ymr;

  static LinkedHashSet<YearMonth> get _ymSetGenerator => LinkedHashSet(
      equals: (ym1, ym2) => ym1 == ym2, hashCode: (ym) => ym.hashCode);

  YearMonthRange.emptySet() : _ymr = _ymSetGenerator;

  YearMonthRange(YearMonth from, YearMonth to) : _ymr = _ymSetGenerator {
    int beginM = from.month;
    for (int y = from.year; y <= to.year; y++) {
      for (int m = beginM; m <= 12; m++) {
        _ymr.add(YearMonth(y, m));
        if (y == to.year && m == to.month) {
          break;
        }
      }
      beginM = 1;
    }
  }

  @override
  bool add(YearMonth value) => _ymr.add(value);

  @override
  bool contains(Object? element) => _ymr.contains(element);

  @override
  Iterator<YearMonth> get iterator => _ymr.iterator;

  @override
  int get length => _ymr.length;

  @override
  YearMonth? lookup(Object? element) => _ymr.lookup(element);

  @override
  bool remove(Object? value) => _ymr.remove(value);

  @override
  Set<YearMonth> toSet() => _ymr.toSet();
}
