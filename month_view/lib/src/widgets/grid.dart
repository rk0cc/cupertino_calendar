part of 'widgets.dart';

/// Generate a [GridView] of repersenting all day of current [YearMonth]
class MonthGrid extends StatefulWidget {
  /// Current [YearMonth]
  final YearMonth yearMonth;

  /// Define which weekday as the first day of the week
  final FirstDayOfWeek firstDayOfWeek;

  /// Style preference for [DayBox]
  final DayBoxStyle? dayBoxStyle;

  /// Get holiday in this month
  final List<Holiday> holiday;

  /// Get holiday in this month
  final List<Events> events;

  /// Direction of [Flex]. It also handle the scale of [DayBox] if
  /// applied as [Axis.horizontal]
  final Axis direction;

  final List<DateTime?> _dim;

  /// Create new [GridView] of [yearMonth]
  MonthGrid(this.yearMonth,
      {this.firstDayOfWeek = FirstDayOfWeek.sun,
      this.dayBoxStyle,
      this.direction = Axis.vertical,
      this.events = const <Events>[],
      this.holiday = const <Holiday>[]})
      : _dim = List<DateTime?>.filled(
            firstDayOfWeek.calculatePlaceholderFromStart(yearMonth), null,
            growable: true)
          ..addAll(yearMonth.allDaysInMonth)
          ..addAll(List.filled(
              firstDayOfWeek.calculatePlaceholderFromEnd(yearMonth), null));

  @override
  State<MonthGrid> createState() => MonthGridState();
}

/// State of [MonthGrid]
class MonthGridState extends State<MonthGrid> {
  /// Highlight which [DayBox] contains the same of [DateTime]
  late DateTime currentPicked;

  @override
  void initState() {
    assert(widget._dim.length % 7 == 0,
        "The length of day in month must be able to cover entire row of GridView");

    // Pick today or the first day of month
    currentPicked = widget.yearMonth.todayInThisMonth
        ? DateTime.now()
        : widget.yearMonth.firstDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: widget.direction == Axis.vertical
              ? 1
              : widget.dayBoxStyle?.landscapeWidthRatio ?? 1.5),
      itemCount: widget._dim.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, count) => widget._dim[count] == null
          ? PlaceholderDayBox()
          : GestureDetector(
              onTap: () => setState(() => currentPicked = widget._dim[count]!),
              child: DayBox(
                  isHoliday: (dt) => widget.holiday
                      .where((hd) =>
                          hd.dateTime.year == dt.year &&
                          hd.dateTime.month == dt.month &&
                          hd.dateTime.day == dt.day)
                      .isNotEmpty,
                  hasEvent: (dt) => widget.events
                      .where((ed) =>
                          (ed.from.isAfter(dt) || ed.from.isAtSameMomentAs(dt)) &&
                          (ed.to.isBefore(dt) || ed.to.isAtSameMomentAs(dt)))
                      .isNotEmpty,
                  pickedCondition: (dt) =>
                      dt.year == currentPicked.year &&
                      dt.month == currentPicked.month &&
                      dt.day == currentPicked.day,
                  day: widget._dim[count]!,
                  style: widget.dayBoxStyle)));
}
