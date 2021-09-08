part of 'styles.dart';

@immutable
class CalendarTopBarStyle {
  final double iconSize;
  final Color? active;
  final Color? inactive;
  final TextStyle? yearMonthTextStyle;
  final MonthApperance yearMonthFormat;

  const CalendarTopBarStyle(
      {this.iconSize = 28,
      this.active,
      this.inactive,
      this.yearMonthTextStyle,
      this.yearMonthFormat = MonthApperance.fullname});
}

enum MonthApperance { fullname, short_name, numeric }

extension MonthApperancePattern on MonthApperance {
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
