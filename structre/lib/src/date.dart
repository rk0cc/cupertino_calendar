class YearMonth extends DateTime {
  static void _disallowNonFirstDate(YearMonth ym) {
    assert(ym.day == 1 &&
        ym.hour == 0 &&
        ym.minute == 0 &&
        ym.second == 0 &&
        ym.millisecond == 0 &&
        ym.microsecond == 0);
  }

  YearMonth(int year, int month) : super(year, month) {
    _disallowNonFirstDate(this);
  }

  /// Do the same of the [DateTime.now] but return it's year and month value
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
}
