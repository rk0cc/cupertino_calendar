import 'style.dart';
import 'handlers.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_calendar_month_view/month_view.dart'
    hide CalendarTopBarStyle, DayBoxStyle;
import 'package:cupertino_calendar_date_reminds_view/date_reminds_view.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:cupertino_calendar/module.dart' show DateRemind;

/// Display calendar in [CupertinoApp]
class CupertinoCalendar extends StatefulWidget {
  final GlobalKey<CupertinoCalendarMonthViewState> _calendarControlKey;

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
      : _calendarControlKey =
            GlobalKey(debugLabel: "Cupertino Calendar global control key");

  @override
  State<CupertinoCalendar> createState() => CupertinoCalendarState();

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

/// Internal mixin that sperate different context when build
mixin CupertinoCalendarUIDefiner {
  final double _marginSide = 2.5;

  /// A widget that showing the calendar
  CupertinoCalendarMonthView calendarContext(
      BuildContext context, Orientation orientation);

  /// Additional context that outside [calendarContext]
  Widget? additionalContext(BuildContext context, Orientation orientation) =>
      null;

  @override
  // ignore: override_on_non_overriding_member
  Widget build(BuildContext context) => Container(
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
                    Expanded(child: calendarContext(context, orientation)),
                    SizedBox(
                        height: (MediaQuery.of(context).size.height / 3.5) -
                            _marginSide,
                        child: additionalContext(context, orientation))
                  ])));
}

/// A [State] for [CupertinoCalendar]
class CupertinoCalendarState extends State<CupertinoCalendar>
    with CupertinoCalendarUIDefiner {
  late DateTime _cpd;
  late DateRemindList _currentConfigDR;

  @override
  void initState() {
    _cpd = DateTime.now();
    _currentConfigDR = widget.dateReminds ?? DateRemindList();
    super.initState();
  }

  @override
  CupertinoCalendarMonthView calendarContext(
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

  @override
  CupertinoCalendarDateRemindsView additionalContext(
          BuildContext context, Orientation orientation) =>
      CupertinoCalendarDateRemindsView(
        _cpd,
        dateRemindList: DateRemindList(
            _currentConfigDR.where((dr) => dr.isOngoing(_cpd)).toList()),
        dateRemindWidgetStyle: widget.style.dateRemindWidgetStyle,
        onPress: widget.selectedDateRemindHandlerPreference?.onPress,
        onLongPress: widget.selectedDateRemindHandlerPreference?.onLongPress,
      );
}
