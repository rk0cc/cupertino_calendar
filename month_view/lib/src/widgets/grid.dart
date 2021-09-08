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
  final List<Holiday> holidayInThisMonth;

  /// Get holiday in this month
  final List<Events> eventsInThisMonth;

  final List<DateTime?> _dim;

  /// Create new [GridView] of [yearMonth]
  MonthGrid(this.yearMonth,
      {this.firstDayOfWeek = FirstDayOfWeek.sun,
      this.dayBoxStyle,
      this.eventsInThisMonth = const <Events>[],
      this.holidayInThisMonth = const <Holiday>[]})
      : _dim = List<DateTime?>.filled(
            firstDayOfWeek.calculatePlaceholderFromStart(yearMonth), null)
          ..addAll(yearMonth.allDaysInMonth)
          ..addAll(List.filled(
              firstDayOfWeek.calculatePlaceholderFromEnd(yearMonth), null)),
        assert(
            holidayInThisMonth
                .where((hd) =>
                    hd.dateTime.year != yearMonth.year ||
                    hd.dateTime.month != yearMonth.month)
                .isEmpty,
            "Only related year and month can be existed in current MonthView's holiday list"),
        assert(
            eventsInThisMonth.where((ed) {
              if (ed.from.year > yearMonth.year || ed.to.year < yearMonth.year)
                return true;
              else if (ed.from.year == yearMonth.year &&
                  ed.from.month > yearMonth.month)
                return true;
              else if (ed.to.year == yearMonth.year &&
                  ed.to.month < yearMonth.month) return true;
              return false;
            }).isEmpty,
            "Only happened during this YearMonth can be existed in current MonthView's event list");

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
    currentPicked = widget.yearMonth.todayInThisMonth
        ? DateTime.now()
        : widget.yearMonth.firstDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FittedBox(
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: widget._dim.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, count) => widget._dim[count] == null
              ? PlaceholderDayBox()
              : DayBox(
                  isHoliday: (dt) => widget.holidayInThisMonth
                      .where((hd) => hd.dateTime.isAtSameMomentAs(dt))
                      .isNotEmpty,
                  hasEvent: (dt) => widget.eventsInThisMonth
                      .where((ed) => (ed.from.isAfter(dt) ||
                          ed.from.isAtSameMomentAs(dt) &&
                              (ed.to.isBefore(dt) ||
                                  ed.to.isAtSameMomentAs(dt))))
                      .isNotEmpty,
                  pickedCondition: (dt) =>
                      dt.year == currentPicked.year &&
                      dt.month == currentPicked.month &&
                      dt.day == currentPicked.day,
                  day: widget._dim[count]!,
                  style: widget.dayBoxStyle)));
}
