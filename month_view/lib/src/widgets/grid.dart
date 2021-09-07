part of 'widgets.dart';

class MonthGrid extends StatefulWidget {
  final YearMonth yearMonth;
  final FirstDayOfWeek firstDayOfWeek;
  final List<DateTime?> _dim;
  final DayBoxStyle? dayBoxStyle;

  MonthGrid(this.yearMonth,
      {this.firstDayOfWeek = FirstDayOfWeek.sun, this.dayBoxStyle})
      : _dim = List<DateTime?>.filled(
            firstDayOfWeek.calculatePlaceholderFromStart(yearMonth), null)
          ..addAll(yearMonth.allDaysInMonth)
          ..addAll(List.filled(
              firstDayOfWeek.calculatePlaceholderFromEnd(yearMonth), null));

  @override
  State<MonthGrid> createState() => MonthGridState();
}

class MonthGridState extends State<MonthGrid> {
  late DateTime currentPicked;

  @override
  void initState() {
    currentPicked = widget.yearMonth.todayInThisMonth
        ? DateTime.now()
        : widget.yearMonth.firstDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FittedBox(
      child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: widget._dim.length,
          itemBuilder: (context, count) => widget._dim[count] == null
              ? PlaceholderDayBox()
              : DayBox(
                  condition: (dt) =>
                      dt.year == currentPicked.year &&
                      dt.month == currentPicked.month &&
                      dt.day == currentPicked.day,
                  day: widget._dim[count]!,
                  style: widget.dayBoxStyle)));
}
