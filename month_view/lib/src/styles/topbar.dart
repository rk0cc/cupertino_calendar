part of 'styles.dart';

/// Define style of [CalendarTopBar]
@immutable
class CalendarTopBarStyle {
  /// Sizes of the icon
  final double iconSize;

  /// [Color] when this button is active
  final Color? active;

  /// [Color] when this button is inactive
  /// (When reached first or last range of [YearMonth])
  final Color? inactive;

  /// [TextStyle] for displaying [YearMonth]'s format string
  final TextStyle? yearMonthTextStyle;

  /// Apperance of displaying [YearMonth]'s format string
  ///
  /// Default uses [MonthApperance.fullname]
  final MonthApperance yearMonthFormat;

  /// Create styles preference of [CalendarTopBar]
  const CalendarTopBarStyle(
      {this.iconSize = 28,
      this.active,
      this.inactive,
      this.yearMonthTextStyle,
      this.yearMonthFormat = MonthApperance.fullname});
}

/// Determine what pattern will be used for displaying [YearMonth] string
enum MonthApperance {
  /// Display month as word and year
  fullname,

  /// Display short-formed month and year
  short_name,

  /// Display month with number and year
  numeric
}

/// Generating pattern of targeted value of [MonthApperance]
extension MonthApperancePattern on MonthApperance {
  /// Get a pattern string for
  /// [DateFormat](https://api.flutter.dev/flutter/intl/DateFormat-class.html)
  /// package
  ///
  /// If [hasLocale] is true, it return standarised ICU pattern to prepare
  /// localization
  String dateFormatPattern(bool hasLocale) {
    switch (this) {
      case MonthApperance.fullname:
        return hasLocale ? "yMMMM" : "MMMM, yyyy";
      case MonthApperance.short_name:
        return hasLocale ? "yMMM" : "MMM, yyyy";
      case MonthApperance.numeric:
        return hasLocale ? "yM" : "M/yyyy";
    }
  }
}
