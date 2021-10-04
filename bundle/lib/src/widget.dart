import 'style.dart';
import 'handlers.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_calendar_month_view/month_view.dart'
    hide CalendarTopBarStyle, DayBoxStyle;
import 'package:cupertino_calendar_date_reminds_view/date_reminds_view.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:cupertino_calendar/module.dart' show DateRemind;

enum _CalendarRenderMode { with_dr, with_empty }

final double _marginSide = 2.5;

/// A [Function] for returning [DateRemindList] from [Future]
///
/// It commonly used if the data of [DateRemind] is came from Internet
typedef FutureDateRemindHandler = Future<DateRemindList> Function();

/// Display calendar in [CupertinoApp]
class CupertinoCalendar extends StatefulWidget {
  final GlobalKey<CupertinoCalendarMonthViewState> _calendarControlKey;

  final _CalendarRenderMode _renderMode;

  /// Available [YearMonth] range for this calendar
  ///
  /// **Please ensure the range is included [YearMonth.now]. Otherwise build fail.**
  final YearMonthRange range;

  /// (Optional) provides [DateRemindList] for listing [Events] and [Holiday] in
  /// this calendar
  final DateRemindList? dateReminds;

  /// Define which weekday as the first day of the week
  ///
  /// Default uses [FirstDayOfWeek.sun], you can set it as [FirstDayOfWeek.sat]
  /// or [FirstDayOfWeek.mon] depending your region
  final FirstDayOfWeek firstDayOfWeek;

  /// Implement [SafeArea] that to prevent calendar is covered
  /// by [CupertinoNavigationBar]
  final bool safeArea;

  /// Styles preference for [CupertinoCalendar] that override the default style
  /// from system
  final CupertinoCalendarStyle style;

  /// Define actions when selected [DateRemind]
  final SelectedDateRemindHandlerPreference?
      selectedDateRemindHandlerPreference;

  /// Unified [GlobalKey] generator
  static GlobalKey<CupertinoCalendarMonthViewState> get _createNewGK =>
      GlobalKey(debugLabel: "Cupertino Calendar global control key");

  /// Implement [CupertinoCalendar]
  ///
  /// This widget will used entire space of [CupertinoPageScaffold],
  /// and it will rolled calendar with customizable widget in later version
  CupertinoCalendar(this.range,
      {this.dateReminds,
      this.selectedDateRemindHandlerPreference,
      this.firstDayOfWeek = FirstDayOfWeek.sun,
      this.style = const CupertinoCalendarStyle(),
      this.safeArea = true})
      : _renderMode = _CalendarRenderMode.with_dr,
        _calendarControlKey = _createNewGK;

  /// Implement [CupertinoCalendar] but leave a white space below
  ///
  /// Since it can't show event information, it throws [AssertionError] if
  /// applying [Events] into [dateReminds] and has no affect when applying
  /// [style.dateRemindWidgetStyle]
  CupertinoCalendar.leaveWhiteSpace(this.range,
      {this.dateReminds,
      this.firstDayOfWeek = FirstDayOfWeek.sun,
      this.style = const CupertinoCalendarStyle(),
      this.safeArea = true})
      : assert(dateReminds?.events.isEmpty ?? true,
            "Disallow listing event in custom context"),
        _renderMode = _CalendarRenderMode.with_empty,
        selectedDateRemindHandlerPreference = null,
        _calendarControlKey = _createNewGK;

  /// Get [DateRemindList] from future and wrap [CupertinoCalendar] inside of
  /// [FutureBuilder]
  static FutureBuilder<DateRemindList> getDateRemindsFromFuture(
          YearMonthRange range,
          {required FutureDateRemindHandler handler,
          SelectedDateRemindHandlerPreference?
              selectedDateRemindHandlerPreference,
          FirstDayOfWeek firstDayOfWeek = FirstDayOfWeek.sun,
          CupertinoCalendarStyle style = const CupertinoCalendarStyle(),
          bool safeArea = true}) =>
      FutureBuilder(
          future: handler(),
          builder: (context, result) {
            if (result.hasError) {
              throw result.error!;
            } else if (result.hasData) {
              return CupertinoCalendar(range,
                  dateReminds: result.data!,
                  selectedDateRemindHandlerPreference:
                      selectedDateRemindHandlerPreference,
                  firstDayOfWeek: firstDayOfWeek,
                  safeArea: safeArea,
                  style: style);
            }
            return Center(
                child: CupertinoActivityIndicator(radius: 48, animating: true));
          });

  @override
  State<CupertinoCalendar> createState() {
    switch (_renderMode) {
      case _CalendarRenderMode.with_dr:
        return CupertinoCalendarBasicState();
      case _CalendarRenderMode.with_empty:
        return CupertinoCalendarStateWithEmpty();
    }
  }

  /// Get [CupertinoCalendarMonthViewExternalController] to allow control
  /// [CupertinoCalendarMonthView] context outside
  /// [CupertinoCalendarMonthViewState]
  ///
  /// P.S. If you want to uses it, please create an object of
  /// [CupertinoCalendar] at first:
  /// ```dart
  /// // This example is using as stateless
  ///
  /// class ImplementCalendarClass extends StatelessWidget {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final calendar = CupertinoCalendar(YearMonthRange(from, to));
  ///     final controller = calendar.controller;
  ///
  ///     return CupertinoPageScaffold(
  ///       navigationBar: const CupertinoNavigationBar(
  ///         middle: Text('Sample Code'),
  ///         // Implement controller action there
  ///       ),
  ///       child: calendar
  ///     );
  ///   }
  /// }
  /// ```
  CupertinoCalendarMonthViewExternalController get controller =>
      CupertinoCalendarMonthViewExternalController(_calendarControlKey);
}

/// A [State] for [CupertinoCalendar]
abstract class _CupertinoCalendarState extends State<CupertinoCalendar> {
  late DateTime _cpd;
  late DateRemindList _currentConfigDR;

  /// Identify the enum value is matched to prevent swapped [State]
  _CalendarRenderMode get _rmValue;

  @override
  void initState() {
    _cpd = DateTime.now();
    super.initState();
  }

  /// Reload current [DateRemindList] from [widget.dateReminds]
  void updateDateReminds() {
    _currentConfigDR = widget.dateReminds ?? DateRemindList();
  }

  /// Context that will parse to [build] when executed [updateDateReminds]
  Widget render(BuildContext context);

  @override
  Widget build(BuildContext context) {
    assert(_rmValue == widget._renderMode,
        "The context mode has been swapped unexpectedly");
    updateDateReminds();
    return render(context);
  }
}

/// To standarize the context layout in [CupertinoCalendar]
mixin CalendarContextMaker on _CupertinoCalendarState {
  /// Actual widget from [CupertinoCalendarMonthView]
  CupertinoCalendarMonthView monthView(
      BuildContext context, Orientation orientation);

  /// Additional context that will display under or right hand side of the
  /// [CupertinoCalendarMonthView]
  Widget? additionalContext(BuildContext context, Orientation orientation);

  /// Wrapping preference of [SizedBox] with provided [context] and
  /// [orientation]
  SizedBox _additionalContextWrapper(
          BuildContext context, Orientation orientation) =>
      SizedBox(
          height: (orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height / 3.5)
                  : MediaQuery.of(context).size.height) -
              _marginSide,
          width: (orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2.5) -
              _marginSide,
          child: additionalContext(context, orientation));

  @override
  Widget render(BuildContext context) => Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(_marginSide),
      child: OrientationBuilder(
          builder: (context, orientation) => Flex(
                  direction: orientation == Orientation.portrait
                      ? Axis.vertical
                      : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: monthView(context, orientation)),
                    orientation == Orientation.landscape && widget.safeArea
                        ? SafeArea(
                            child:
                                _additionalContextWrapper(context, orientation))
                        : _additionalContextWrapper(context, orientation)
                  ])));
}

/// A [State] from [CupertinoCalendar] that included
/// [CupertinoCalendarMonthView.withDateRemind] and
/// [CupertinoCalendarDateRemindsView]
class CupertinoCalendarBasicState extends _CupertinoCalendarState
    with CalendarContextMaker {
  @override
  _CalendarRenderMode get _rmValue => _CalendarRenderMode.with_dr;

  SizedBox _dateRemindWidget(BuildContext context, Orientation orientation) =>
      SizedBox(
          height: (orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height / 3.5)
                  : MediaQuery.of(context).size.height) -
              _marginSide,
          width: (orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2.5) -
              _marginSide,
          child: CupertinoCalendarDateRemindsView(
            _cpd,
            dateRemindList: DateRemindList(
                _currentConfigDR.where((dr) => dr.isOngoing(_cpd)).toList()),
            dateRemindWidgetStyle: widget.style.dateRemindWidgetStyle,
            onPress: widget.selectedDateRemindHandlerPreference?.onPress,
            onLongPress:
                widget.selectedDateRemindHandlerPreference?.onLongPress,
          ));

  @override
  Widget additionalContext(BuildContext context, Orientation orientation) =>
      _dateRemindWidget(context, orientation);

  @override
  CupertinoCalendarMonthView monthView(
          BuildContext context, Orientation orientation) =>
      CupertinoCalendarMonthView.withDateRemind(
          key: widget._calendarControlKey,
          orientation: orientation,
          safeArea: widget.safeArea,
          dateRemindList: _currentConfigDR,
          yearMonthRange: widget.range,
          onSelectedDate: (pd) => Future.delayed(
              Duration.zero, () async => setState(() => _cpd = pd)),
          firstDayOfWeek: widget.firstDayOfWeek,
          keepPage: true,
          dayBoxStyle: widget.style.dayBoxStyle,
          topBarStyle: widget.style.calendarTopBarStyle);
}

/// A [State] from [CupertinoCalendar] that included [CupertinoCalendarMonthView]
/// only and leave empty below
class CupertinoCalendarStateWithEmpty extends _CupertinoCalendarState
    with CalendarContextMaker {
  @override
  _CalendarRenderMode get _rmValue => _CalendarRenderMode.with_empty;

  @override
  Widget? additionalContext(BuildContext context, Orientation orientation) =>
      Center();

  @override
  CupertinoCalendarMonthView monthView(
          BuildContext context, Orientation orientation) =>
      CupertinoCalendarMonthView(
          orientation: orientation,
          yearMonthRange: widget.range,
          firstDayOfWeek: widget.firstDayOfWeek,
          dayBoxStyle: widget.style.dayBoxStyle,
          topBarStyle: widget.style.calendarTopBarStyle,
          keepPage: true,
          key: widget._calendarControlKey,
          safeArea: widget.safeArea,
          onSelectedDate: (pd) => Future.delayed(
              Duration.zero, () async => setState(() => _cpd = pd)));
}
