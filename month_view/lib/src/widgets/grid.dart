part of 'widgets.dart';

typedef CurrentDatePickedEvent = void Function(DateTime currentPicked);

/// Generate a [GridView] of repersenting all day of current [YearMonth]
class MonthGrid extends StatefulWidget {
  /// Current [YearMonth]
  final YearMonth yearMonth;

  /// Define which weekday as the first day of the week
  final FirstDayOfWeek firstDayOfWeek;

  /// Style preference for [DayBox]
  final DayBoxStyle? dayBoxStyle;

  /// Get holiday in this month, including previous and next month
  final List<Holiday> holiday;

  /// Get events in this month, including previous and next month between
  /// duration
  final List<Events> events;

  /// Direction of [Flex]. It also handle the scale of [DayBox] if
  /// applied as [Axis.horizontal]
  final Axis direction;

  final CurrentDatePickedEvent currentDatePickedEvent;

  final List<DateTime?> _dim;

  /// Create new [GridView] of [yearMonth]
  MonthGrid(this.yearMonth,
      {required this.currentDatePickedEvent,
      this.firstDayOfWeek = FirstDayOfWeek.sun,
      this.dayBoxStyle,
      this.direction = Axis.vertical,
      this.events = const <Events>[],
      this.holiday = const <Holiday>[]})
      : assert(_checkHolidayListReduced(holiday, yearMonth)),
        assert(_checkEventsListReduced(events, yearMonth)),
        _dim = List<DateTime?>.filled(
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
    currentPicked = getDefaultSelectedDate(widget.yearMonth);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Center(
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: widget.direction == Axis.vertical
                  ? 1
                  : widget.dayBoxStyle?.landscapeWidthRatio ??
                      MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height),
          itemCount: widget._dim.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, count) => widget._dim[count] == null
              ? PlaceholderDayBox()
              : GestureDetector(
                  onTap: () {
                    setState(() => currentPicked = widget._dim[count]!);
                    widget.currentDatePickedEvent(currentPicked);
                  },
                  child: DayBox(
                      isHoliday: (dt) => widget.holiday
                          .where((hd) =>
                              hd.dateTime.year == dt.year &&
                              hd.dateTime.month == dt.month &&
                              hd.dateTime.day == dt.day)
                          .isNotEmpty,
                      hasEvent: (dt) => widget.events
                          .where((ed) =>
                              (ed.from.isAfter(dt) ||
                                  ed.from.isAtSameMomentAs(dt)) &&
                              (ed.to.isBefore(dt) ||
                                  ed.to.isAtSameMomentAs(dt)))
                          .isNotEmpty,
                      pickedCondition: (dt) =>
                          dt.year == currentPicked.year &&
                          dt.month == currentPicked.month &&
                          dt.day == currentPicked.day,
                      day: widget._dim[count]!,
                      style: widget.dayBoxStyle))));
}

List<YearMonth> _getValidAppearedMonth(YearMonth currentYearMonth) {
  List<YearMonth> vAYM = [];
  if (currentYearMonth.month == 1) {
    vAYM.add(YearMonth(currentYearMonth.year - 1, 12));
  } else {
    vAYM.add(YearMonth(currentYearMonth.year, currentYearMonth.month - 1));
  }
  vAYM.add(currentYearMonth);
  if (currentYearMonth.month == 12) {
    vAYM.add(YearMonth(currentYearMonth.year + 1, 1));
  } else {
    vAYM.add(YearMonth(currentYearMonth.year, currentYearMonth.month + 1));
  }
  return vAYM..sort((ym1, ym2) => ym2.compareTo(ym1));
}

bool _checkHolidayListReduced(
    List<Holiday> holiday, YearMonth currentYearMonth) {
  var validYM = _getValidAppearedMonth(currentYearMonth);
  for (Holiday ht in holiday) {
    if (validYM
        .where((vym) => vym == YearMonth.dateTime(ht.dateTime))
        .isEmpty) {
      return false;
    }
  }
  return true;
}

bool _checkEventsListReduced(List<Events> events, YearMonth currentYearMonth) {
  var validYM = _getValidAppearedMonth(currentYearMonth);
  for (Events et in events) {
    if (YearMonth.dateTime(et.from) < validYM.first &&
        YearMonth.dateTime(et.to) > validYM.last) {
      // It definity during event
      continue;
    } else if (validYM
        .where((vym) =>
            vym == YearMonth.dateTime(et.from) ||
            vym == YearMonth.dateTime(et.to))
        .isEmpty) {
      return false;
    }
  }
  return true;
}

/// Get default selected date
///
/// If [cym.todayInThisMonth] true, return [DateTime.now].
/// Otherwise, return [cym.firstDay]
DateTime getDefaultSelectedDate(YearMonth cym) =>
    cym.todayInThisMonth ? DateTime.now() : cym.firstDay;
