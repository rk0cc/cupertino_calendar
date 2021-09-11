import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';

import 'widgets/widgets.dart' hide MonthGridState;
import 'styles/styles.dart';

/// A completed [Widget] for displaying month view
class CupertinoCalendarMonthView extends StatefulWidget {
  /// The range of [YearMonth]
  ///
  /// Please ensure the range is included [YearMonth.now]
  final YearMonthRange yearMonthRange;

  /// Styles preference for [DayBox]
  final DayBoxStyle? dayBoxStyle;

  /// Styles preference for [CalendarTopBar]
  final CalendarTopBarStyle? topBarStyle;

  /// A list of [Events] and [Holiday] which will affect [DayBox] context
  ///
  /// (Only available in [CupertinoCalendarMonthView.withDateRemind])
  final DateRemindList dateRemindList;

  /// The weekday of beginning of the calendar
  final FirstDayOfWeek firstDayOfWeek;

  /// Required [SafeArea] for adjusting widget render position
  final bool safeArea;

  /// Create basic [CupertinoCalendarMonthView]
  CupertinoCalendarMonthView({
    this.dayBoxStyle,
    this.topBarStyle,
    this.safeArea = true,
    required this.yearMonthRange,
    this.firstDayOfWeek = FirstDayOfWeek.sun,
  })  : assert(yearMonthRange.where((ym) => ym == YearMonth.now()).isNotEmpty,
            "The range must included this month"),
        dateRemindList = DateRemindList();

  /// Create [CupertinoCalendarMonthView] with [DateRemindList] supported
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

/// A [State] class of [CupertinoCalendarMonthView]
///
/// It only appeared in module library on default export
class CupertinoCalendarMonthViewState
    extends State<CupertinoCalendarMonthView> {
  /// The [YearMonth] object that current picked
  late YearMonth currentYearMonth;

  /// A controller widget for controlling [PageView] which displaying
  /// [currentYearMonth] calendar
  late PageController monthViewController;

  @override
  void initState() {
    // Default use today's year and month
    currentYearMonth = YearMonth.now();
    super.initState();
    monthViewController = PageController(
        initialPage: widget.yearMonthRange.indexWhere(currentYearMonth),
        keepPage: false);
  }

  @override
  void dispose() {
    monthViewController.dispose();
    super.dispose();
  }

  CalendarTopBar _topbar(BuildContext context, Axis axis) => CalendarTopBar(
      barOrientation: axis,
      yearMonth: currentYearMonth,
      style: widget.topBarStyle,
      range: widget.yearMonthRange,
      onPrevious: () => monthViewController.previousPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut),
      onNext: () => monthViewController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut));

  PageView _monthView(BuildContext context, Orientation orientation) => PageView.builder(
      controller: monthViewController,
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
