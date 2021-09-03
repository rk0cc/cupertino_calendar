void _disallowNonFirstDate(YearMonth ym) {
  assert(ym.day == 0 &&
      ym.hour == 0 &&
      ym.minute == 0 &&
      ym.second == 0 &&
      ym.millisecond == 0 &&
      ym.microsecond == 0);
}

class YearMonth extends DateTime {
  final UnsupportedError _disallowModify =
      UnsupportedError("You can not add or subtract time in YearMonth");

  YearMonth(int year, int month) : super(year, month) {
    _disallowNonFirstDate(this);
  }

  /// Do the same of the [DateTime.now] but return it's year and month value
  /// only
  factory YearMonth.now() {
    var n = DateTime.now();
    return YearMonth(n.year, n.month);
  }

  /// Throws [UnsupportedError] if trying to modify [YearMonth]'s date and time
  @Deprecated("Please cast back to DateTime before modification")
  @override
  DateTime add(Duration duration) {
    throw _disallowModify;
  }

  /// Throws [UnsupportedError] if trying to modify [YearMonth]'s date and time
  @Deprecated("Please cast back to DateTime before modification")
  @override
  DateTime subtract(Duration duration) {
    throw _disallowModify;
  }
}
