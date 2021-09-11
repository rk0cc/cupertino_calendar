import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';

import 'widgets/widgets.dart' hide MonthGridState;
import 'styles/styles.dart';

class CupertinoCalendarMonthView extends StatefulWidget {
  final YearMonthRange yearMonthRange;
  final DayBoxStyle? dayBoxStyle;
  final CalendarTopBarStyle? topBarStyle;
  final DateRemindList dateRemindList;
  final Axis scrollDirection;
  final FirstDayOfWeek firstDayOfWeek;

  CupertinoCalendarMonthView(
      {this.dayBoxStyle,
      this.topBarStyle,
      required this.yearMonthRange,
      this.firstDayOfWeek = FirstDayOfWeek.sun,
      this.scrollDirection = Axis.horizontal})
      : assert(yearMonthRange.where((ym) => ym == YearMonth.now()).isNotEmpty,
            "The range must included this month"),
        dateRemindList = DateRemindList();

  CupertinoCalendarMonthView.withDateRemind(
      {this.dayBoxStyle,
      this.topBarStyle,
      this.scrollDirection = Axis.horizontal,
      this.firstDayOfWeek = FirstDayOfWeek.sun,
      required this.dateRemindList,
      required this.yearMonthRange})
      : assert(yearMonthRange.where((ym) => ym == YearMonth.now()).isNotEmpty,
            "The range must included this month");

  @override
  State<CupertinoCalendarMonthView> createState() =>
      CupertinoCalendarMonthViewState();
}

class CupertinoCalendarMonthViewState
    extends State<CupertinoCalendarMonthView> {
  late YearMonth currentYearMonth;
  late PageController _monthViewController;

  @override
  void initState() {
    currentYearMonth = YearMonth.now();
    super.initState();
    _monthViewController = PageController(
        initialPage: widget.yearMonthRange.indexWhere(currentYearMonth));
  }

  CalendarTopBar _topbar(BuildContext context, Axis axis) => CalendarTopBar(
      barOrientation: axis,
      yearMonth: currentYearMonth,
      style: widget.topBarStyle,
      range: widget.yearMonthRange,
      onPrevious: () => _monthViewController.previousPage(
          duration: Duration(seconds: 1), curve: Curves.easeInOut),
      onNext: () => _monthViewController.nextPage(
          duration: Duration(seconds: 1), curve: Curves.easeInOut));

  PageView _monthView(BuildContext context) => PageView.builder(
      controller: _monthViewController,
      onPageChanged: (changedPage) => setState(() =>
          currentYearMonth = widget.yearMonthRange.elementAt(changedPage)),
      scrollDirection: widget.scrollDirection,
      itemCount: widget.yearMonthRange.length,
      itemBuilder: (context, ymc) => MonthGrid(widget.yearMonthRange.elementAt(ymc),
          dayBoxStyle: widget.dayBoxStyle,
          eventsInThisMonth: widget.dateRemindList.events
              .where((e) =>
                  e.from.year <= currentYearMonth.year &&
                  e.from.month <= currentYearMonth.month &&
                  e.to.year >= currentYearMonth.year &&
                  e.to.month >= currentYearMonth.month)
              .toList(),
          holidayInThisMonth: widget.dateRemindList.holiday
              .where((h) =>
                  h.dateTime.year == currentYearMonth.year &&
                  h.dateTime.month == currentYearMonth.month)
              .toList()));

  @override
  Widget build(BuildContext context) => Container(
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width / 2,
          minHeight: MediaQuery.of(context).size.height / 2,
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      child: OrientationBuilder(
          builder: (context, orient) => Flex(
                  direction: orient == Orientation.portrait
                      ? Axis.vertical
                      : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FractionallySizedBox(
                        heightFactor: orient == Orientation.portrait ? 0.15 : 1,
                        widthFactor:
                            orient == Orientation.landscape ? 0.125 : 1,
                        child: _topbar(
                            context,
                            orient == Orientation.portrait
                                ? Axis.horizontal
                                : Axis.vertical)),
                    Expanded(child: FittedBox(child: _monthView(context)))
                  ])));
}
