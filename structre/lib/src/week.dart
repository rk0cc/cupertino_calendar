import 'date.dart' show YearMonth;

/// Define which weekday is the first day of the week
enum FirstDayOfWeek {
  /// Saturday, used for middle-east commonly
  sat,

  /// Sunday, most common one
  sun,

  /// Monday, for europe and some finance industry
  mon
}

/// Calculating from [FirstDayOfWeek]
extension FirstDayOfWeekCalculator on FirstDayOfWeek {
  /// Alias from [DateTime]'s weekday value
  int get weekend {
    switch (this) {
      case FirstDayOfWeek.sat:
        return 6;
      case FirstDayOfWeek.sun:
        return 7;
      case FirstDayOfWeek.mon:
        return 1;
    }
  }

  /// Calculating the placeholder from first day of [YearMonth]
  int calculatePlaceholderFromStart(YearMonth ym) =>
      ((7 - this.weekend) + (ym.firstDay.weekday % 7)) % 7;

  /// Calculating the placeholder from last day of [YearMonth]
  int calculatePlaceholderFromEnd(YearMonth ym) =>
      (this.weekend - ym.lastDay.weekday - 1) % 7;
}
