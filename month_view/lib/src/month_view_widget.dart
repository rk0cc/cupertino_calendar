import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';
import 'widgets/widgets.dart' hide MonthGridState;
import 'styles/styles.dart';

/// A completed [Widget] for displaying month view
class CupertinoCalendarMonthView extends StatefulWidget {
  /// Binding [OrientationBuilder]'s orientation
  final Orientation orientation;

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

  /// A callback event when selected date
  final CurrentDatePickedEvent? onSelectedDate;

  /// Required [SafeArea] for adjusting widget render position
  final bool safeArea;

  /// Keep the latest page of the [MonthGrid]
  final bool keepPage;

  final State<CupertinoCalendarMonthView> _state =
      CupertinoCalendarMonthViewState();

  /// Create basic [CupertinoCalendarMonthView]
  CupertinoCalendarMonthView({
    Key? key,
    this.dayBoxStyle,
    this.topBarStyle,
    this.onSelectedDate,
    this.keepPage = false,
    this.safeArea = true,
    required this.orientation,
    required this.yearMonthRange,
    this.firstDayOfWeek = FirstDayOfWeek.sun,
  })  : assert(yearMonthRange.where((ym) => ym == YearMonth.now()).isNotEmpty,
            "The range must included this month"),
        dateRemindList = DateRemindList(),
        super(key: key);

  /// Create [CupertinoCalendarMonthView] with [DateRemindList] supported
  CupertinoCalendarMonthView.withDateRemind(
      {Key? key,
      this.dayBoxStyle,
      this.topBarStyle,
      this.onSelectedDate,
      this.keepPage = false,
      this.safeArea = true,
      this.firstDayOfWeek = FirstDayOfWeek.sun,
      required this.orientation,
      required this.dateRemindList,
      required this.yearMonthRange})
      : assert(yearMonthRange.where((ym) => ym == YearMonth.now()).isNotEmpty,
            "The range must included this month"),
        super(key: key);

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
  late PageController _monthViewController;

  /// [currentYearMonth]'s index
  late int _cymIndex;

  bool _inited = false;

  CurrentDatePickedEvent get _selectedDateEventHandler =>
      widget.onSelectedDate ?? (cd) {};

  @override
  void initState() {
    // Default use today's year and month
    currentYearMonth = YearMonth.now();
    _cymIndex = widget.yearMonthRange.indexWhere(currentYearMonth);
    super.initState();
    _inited = true;
    _monthViewController =
        PageController(initialPage: _cymIndex, keepPage: widget.keepPage);
    _selectedDateEventHandler(getDefaultSelectedDate(currentYearMonth));
  }

  void _toCurrentMonth() {
    if (_inited) {
      _monthViewController.jumpToPage(_cymIndex);
    }
  }

  void _toAnotherYearMonth(YearMonth yearMonth) {
    if (_inited) {
      int pageNo = widget.yearMonthRange.indexWhere(yearMonth);
      if (pageNo == -1)
        throw RangeError("${yearMonth.formatString()} is not in the range");
      _monthViewController.jumpToPage(pageNo);
    }
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

  PageView _monthView(BuildContext context, Orientation orientation) =>
      PageView.builder(
          controller: _monthViewController,
          onPageChanged: (changedPage) {
            setState(() => currentYearMonth =
                widget.yearMonthRange.elementAt(changedPage));
            _selectedDateEventHandler(getDefaultSelectedDate(currentYearMonth));
          },
          scrollDirection: orientation == Orientation.portrait
              ? Axis.horizontal
              : Axis.vertical,
          itemCount: widget.yearMonthRange.length,
          itemBuilder: (context, ymc) => MonthGrid(
              widget.yearMonthRange.elementAt(ymc),
              currentDatePickedEvent: _selectedDateEventHandler,
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
                  .where((h) =>
                      h.dateTime.year == currentYearMonth.year &&
                      h.dateTime.month == currentYearMonth.month)
                  .toList()));

  Widget _renderContext(BuildContext context, Orientation orient) => Center(
          child: Flex(
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
          ]));

  @override
  Widget build(BuildContext context) => widget.safeArea
      ? SafeArea(child: _renderContext(context, widget.orientation))
      : _renderContext(context, widget.orientation);
}

/// A simple controller for [CupertinoCalendarMonthView] and controll the view
/// by another [Widget] which in the same page
class CupertinoCalendarMonthViewExternalController {
  final GlobalKey<CupertinoCalendarMonthViewState> _stateKey;

  /// Initalize controller with [stateKey]
  ///
  /// [stateKey] must be attached to [CupertinoCalendarMonthView] already
  CupertinoCalendarMonthViewExternalController(
      GlobalKey<CupertinoCalendarMonthViewState> stateKey)
      : _stateKey = stateKey;

  /// Change page to current [YearMonth]
  void toCurrentMonth() => _stateKey.currentState!._toCurrentMonth();

  /// Change another [YearMonth] within [YearMonthRange] in
  /// [CupertinoCalendarMonthView]. Otherwise, throws [RangeError] or call
  /// [onError] if provided
  void toYearMonth(YearMonth yearMonth,
      {void Function(RangeError re)? onError}) {
    try {
      _stateKey.currentState!._toAnotherYearMonth(yearMonth);
    } on RangeError catch (re) {
      (onError ?? (re) => throw re)(re);
    }
  }
}
