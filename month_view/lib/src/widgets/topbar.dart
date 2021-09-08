part of 'widgets.dart';

/// A panel [Widget] for displaying current [YearMonth]
/// and changing to another month
class CalendarTopBar extends StatelessWidget {
  /// Current page of [YearMonth]
  final YearMonth yearMonth;

  /// Range of the begin and end of the [YearMonth] in the calendar
  final YearMonthRange range;

  /// Handler for swapping to previous month
  final void Function() onPrevious;

  /// Handler for swapping to next month
  final void Function() onNext;

  /// Style preference for [CalendarTopBar]
  final CalendarTopBarStyle? style;

  /// Applying locale specific date format
  ///
  /// Leave [Null] for using generic format
  final String? locale;

  CalendarTopBar(
      {required this.yearMonth,
      required this.range,
      required this.onPrevious,
      required this.onNext,
      this.style,
      this.locale});

  @override
  Widget build(BuildContext context) {
    var applyStyle = style ?? CalendarTopBarStyle();
    CupertinoButton btnMaker(IconData icons, void Function()? onPressed) =>
        CupertinoButton(
            child: Icon(icons, size: applyStyle.iconSize),
            onPressed: onPressed,
            color: applyStyle.active,
            disabledColor:
                applyStyle.inactive ?? CupertinoColors.quaternaryLabel);
    return Center(
        child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          btnMaker(CupertinoIcons.left_chevron,
              yearMonth > range.first ? onPrevious : null),
          Text(yearMonth.formatString(
              format:
                  applyStyle.yearMonthFormat.dateFormatPattern(locale != null),
              locale: locale)),
          btnMaker(CupertinoIcons.right_chevron,
              yearMonth < range.last ? onNext : null)
        ]));
  }
}
