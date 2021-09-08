part of 'widgets.dart';

class CalendarTopBar extends StatelessWidget {
  final YearMonth yearMonth;
  final YearMonthRange range;
  final void Function() onPrevious;
  final void Function() onNext;
  final CalendarTopBarStyle? style;
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
