import 'dart:collection' show HashSet;

/// [YearMonth] is a extended class from [DateTime] which only contains [year]
/// and [month] mainly
class YearMonth extends DateTime {
  static void _disallowNonFirstDate(YearMonth ym) {
    assert(ym.day == 1 &&
        ym.hour == 0 &&
        ym.minute == 0 &&
        ym.second == 0 &&
        ym.millisecond == 0 &&
        ym.microsecond == 0);
  }

  /// Create new [YearMonth]
  ///
  /// ## Caution
  ///
  /// **[YearMonth]'s [day] must be `1` and [hour], [minute], [second],
  /// [millisecond] and [microsecond] must be `0`, throws [AssertionError]
  /// if don't obey these requirments**
  YearMonth(int year, int month) : super(year, month) {
    _disallowNonFirstDate(this);
  }

  /// Do the same of the [DateTime.now] but return it's [year] and [month] value
  /// only
  factory YearMonth.now() {
    var n = DateTime.now();
    return YearMonth(n.year, n.month);
  }

  /// Add [duration] that in a month.
  /// Otherwie, throws [AssertionError] if result is not the first date at
  /// 00:00:00.0 of [DateTime]
  @Deprecated("Please cast back to DateTime if decided to modify existed time")
  @override
  YearMonth add(Duration duration) {
    DateTime nYM = super.add(duration);
    _disallowNonFirstDate(nYM as YearMonth);
    return nYM;
  }

  /// Subtract [duration] that in a month.
  /// Otherwie, throws [AssertionError] if result is not the first date at
  /// 00:00:00.0 of [DateTime]
  @Deprecated("Please cast back to DateTime if decided to modify existed time")
  @override
  YearMonth subtract(Duration duration) {
    DateTime nYM = super.subtract(duration);
    _disallowNonFirstDate(nYM as YearMonth);
    return nYM;
  }

  /// Get last date of this [YearMonth]
  ///
  /// Throws [AssertionError] if [YearMonth] is not the first date at
  /// 00:00:00.0
  DateTime get lastDateOfThisMonth {
    _disallowNonFirstDate(this);
    return DateTime(this.year, this.month + 1, 0);
  }

  /// Generate a [Set] of [DateTime] of all day in this [YearMonth]
  ///
  /// Throws [AssertionError] if [YearMonth] is not the first date at
  /// 00:00:00.0
  Set<DateTime> get allDate {
    _disallowNonFirstDate(this);
    Set<DateTime> dates = HashSet();
    for (int d = 1; d <= lastDateOfThisMonth.day; d++) {
      dates.add(DateTime(this.year, this.month, d));
    }
    return dates;
  }
}
