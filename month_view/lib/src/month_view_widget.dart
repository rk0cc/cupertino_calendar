import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';

import 'widgets/widgets.dart' hide MonthGridState;
import 'styles/styles.dart';

class CupertinoCalendarMonthView extends StatefulWidget {
  final YearMonthRange yearMonthRange;
  final DayBoxStyle? dayBoxStyle;
  final CalendarTopBarStyle? topBarStyle;
  final DateRemindList dateRemindList;
  final FirstDayOfWeek firstDayOfWeek;
  final bool safeArea;

  CupertinoCalendarMonthView({
    this.dayBoxStyle,
    this.topBarStyle,
    this.safeArea = true,
    required this.yearMonthRange,
    this.firstDayOfWeek = FirstDayOfWeek.sun,
  })  : assert(yearMonthRange.where((ym) => ym == YearMonth.now()).isNotEmpty,
            "The range must included this month"),
        dateRemindList = DateRemindList();

  CupertinoCalendarMonthView.withDateRemind(
      {this.dayBoxStyle,
      this.topBarStyle,
      this.safeArea = true,
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
        initialPage: widget.yearMonthRange.indexWhere(currentYearMonth),
        keepPage: false);
  }

  @override
  void dispose() {
    _monthViewController.dispose();
    super.dispose();
  }

  CalendarTopBar _topbar(BuildContext context, Axis axis) => CalendarTopBar(
      barOrientation: axis,
      yearMonth: currentYearMonth,
      style: widget.topBarStyle,
      range: widget.yearMonthRange,
      onPrevious: () => _monthViewController.previousPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut),
      onNext: () => _monthViewController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut));

  PageView _monthView(BuildContext context, Orientation orientation) => PageView.builder(
      controller: _monthViewController,
      onPageChanged: (changedPage) => setState(() =>
          currentYearMonth = widget.yearMonthRange.elementAt(changedPage)),
      scrollDirection:
          orientation == Orientation.portrait ? Axis.horizontal : Axis.vertical,
      itemCount: widget.yearMonthRange.length,
      itemBuilder: (context, ymc) => MonthGrid(
          widget.yearMonthRange.elementAt(ymc),
          direction: orientation == Orientation.landscape
              ? Axis.horizontal
              : Axis.vertical,
          dayBoxStyle: widget.dayBoxStyle,
          events: widget.dateRemindList.events
              .where((e) =>
                  e.from.year <= currentYearMonth.year &&
                  e.from.month <= currentYearMonth.month &&
                  e.to.year >= currentYearMonth.year &&
                  e.to.month >= currentYearMonth.month)
              .toList(),
          holiday: widget.dateRemindList.holiday
              .where((h) => h.dateTime.year == currentYearMonth.year && h.dateTime.month == currentYearMonth.month)
              .toList()));

  Widget _renderContext(BuildContext context) => Center(
      child: OrientationBuilder(
          builder: (context, orient) => Flex(
                  direction: orient == Orientation.portrait
                      ? Axis.vertical
                      : Axis.horizontal,
                  children: [
                    _topbar(
                        context,
                        orient == Orientation.portrait
                            ? Axis.horizontal
                            : Axis.vertical),
                    Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.zero,
                            child: _monthView(context, orient)))
                  ])));

  @override
  Widget build(BuildContext context) => widget.safeArea
      ? SafeArea(child: _renderContext(context))
      : _renderContext(context);
}
