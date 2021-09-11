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

  /// The orientation of the [CalendarTopBar]
  final Axis barOrientation;

  /// Create top bar of the calendar
  CalendarTopBar(
      {required this.yearMonth,
      required this.range,
      required this.onPrevious,
      required this.onNext,
      this.barOrientation = Axis.horizontal,
      this.style,
      this.locale});

  @override
  Widget build(BuildContext context) {
    var applyStyle = style ?? CalendarTopBarStyle();

    // Factory method for building button
    CupertinoButton btnMaker(IconData icons, void Function()? onPressed) =>
        CupertinoButton(
            child: Icon(icons, size: applyStyle.iconSize),
            onPressed: onPressed,
            color: applyStyle.active,
            disabledColor:
                applyStyle.inactive ?? CupertinoColors.quaternaryLabel);

    List<Widget> renderPos = [
      btnMaker(
          barOrientation == Axis.horizontal
              ? CupertinoIcons.left_chevron // Horizontal
              : CupertinoIcons.chevron_up, // Vertical
          yearMonth > range.first
              ? onPrevious
              : null), // Disallow controll when reached limit
      Text(
          yearMonth.formatString(
              format:
                  applyStyle.yearMonthFormat.dateFormatPattern(locale != null),
              locale: locale),
          softWrap: true,
          textAlign: TextAlign.center),
      btnMaker(
          barOrientation == Axis.horizontal
              ? CupertinoIcons.right_chevron // Horizontal
              : CupertinoIcons.chevron_down, // Vertical
          yearMonth < range.last
              ? onNext
              : null) // Disallow controll when reached limit
    ];
    return Container(
        padding: EdgeInsets.zero,
        width: barOrientation == Axis.horizontal
            ? double.infinity
            : MediaQuery.of(context).size.width / 8,
        height: barOrientation == Axis.vertical
            ? double.infinity
            : MediaQuery.of(context).size.height / 8,
        child: Flex(
            direction: barOrientation,
            mainAxisAlignment: barOrientation == Axis.horizontal
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: renderPos));
  }
}
