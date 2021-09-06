import 'dart:collection' show LinkedHashSet, SetBase;
import 'package:intl/intl.dart';
import 'package:quiver/core.dart' show hash2;

/// Create an object that only contains [year] and [month] only
class YearMonth implements Comparable<YearMonth> {
  /// Year which follow [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
  /// standard of the year format
  final int year;

  /// Month between `1` to  `12`
  ///
  /// Unlike [DateTime], assign outranged value can not adjust year's value.
  /// However, throws [AssertionError] insteaded
  final int month;

  /// Create new [YearMonth]'s [year] and [month] with valid value
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

  /// Compare this [YearMonth] and [compare] the same
  @override
  bool operator ==(Object compare) =>
      // ignore: test_types_in_equals
      _checkCompreObject(compare) &&
      (compare as YearMonth).compareTo(this) == 0;

  /// Compare this [YearMonth] is greater than [compare]
  bool operator >(Object compare) =>
      _checkCompreObject(compare) && (compare as YearMonth).compareTo(this) > 0;

  /// Combine operator of  [==] and [>]
  bool operator >=(Object compare) =>
      _checkCompreObject(compare) &&
      (compare as YearMonth).compareTo(this) >= 0;

  /// Compare this [YearMonth] is lesser than [compare]
  bool operator <(Object compare) =>
      _checkCompreObject(compare) && (compare as YearMonth).compareTo(this) < 0;

  /// Combine operator of  [==] and [<]
  bool operator <=(Object compare) =>
      _checkCompreObject(compare) &&
      (compare as YearMonth).compareTo(this) <= 0;

  /// Hash code from [Obejct.hashCode], but not design for using [==].
  ///
  /// Instead, is specific for [YearMonthRange]
  @override
  int get hashCode => hash2(year.hashCode, month.hashCode);

  /// Implemented from [Comparable] which equal `0` means this and [other] are
  /// the same, greater than `0` means [other] is greater and lesser than `0`
  /// means [other] is lesser
  ///
  /// It also uses the condition for operator [==], [>], [<], [>=] and [<=]
  @override
  int compareTo(YearMonth other) =>
      ((other.year - this.year) * 12) + (other.month - this.month);
}

/// A range of [YearMonth] with inheritance from [SetBase]
class YearMonthRange extends SetBase<YearMonth> {
  final Set<YearMonth> _ymr;

  static LinkedHashSet<YearMonth> get _ymSetGenerator => LinkedHashSet(
      equals: (ym1, ym2) => ym1 == ym2, hashCode: (ym) => ym.hashCode);

  /// Generate [Set] with absolutly nothing inside
  YearMonthRange.emptySet() : _ymr = _ymSetGenerator;

  /// Generate [Set] with all [YearMonth] between [from] and [to]
  ///
  /// Throws [AssertionError] if [from] is greater than [to]
  YearMonthRange(YearMonth from, YearMonth to)
      : assert(from <= to),
        _ymr = _ymSetGenerator {
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
    assert(_ymr.length == from.compareTo(to) + 1);
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

  /// [toList] with orded by the ascending [YearMonth] value
  ///
  /// And default [growable] is false
  @override
  List<YearMonth> toList({bool growable = false}) {
    List<YearMonth> _l = _ymr.toList();
    _l.sort((a, b) => a.compareTo(b));
    return List.from(_l, growable: growable);
  }
}

/// Get standarise [DateTime] string which is minified ISO 8061
String getDTString(DateTime dateTime) =>
    DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
