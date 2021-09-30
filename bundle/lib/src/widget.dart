import 'style.dart';
import 'handlers.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_calendar_month_view/month_view.dart'
    hide CalendarTopBarStyle, DayBoxStyle;
import 'package:cupertino_calendar_date_reminds_view/date_reminds_view.dart';
import 'package:cupertino_calendar_structre/structre.dart';

class CupertinoCalendar extends StatefulWidget {
  final GlobalKey<CupertinoCalendarMonthViewState> _calendarControlKey;
  final YearMonthRange range;
  final DateRemindList? dateReminds;
  final FirstDayOfWeek firstDayOfWeek;
  final bool safeArea;
  final CupertinoCalendarStyle style;
  final SelectedDateRemindHandlerPreference?
      selectedDateRemindHandlerPreference;

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

  GlobalKey<CupertinoCalendarMonthViewState> get controllerKey =>
      _calendarControlKey;
}

final double _marginSide = 2.5;

class CupertinoCalendarState extends State<CupertinoCalendar> {
  late DateTime _cpd;
  late DateRemindList _currentConfigDR;

  @override
  void initState() {
    _cpd = DateTime.now();
    _currentConfigDR = widget.dateReminds ?? DateRemindList();
    super.initState();
  }

  @override
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
                    Expanded(
                        child: CupertinoCalendarMonthView.withDateRemind(
                            key: widget._calendarControlKey,
                            orientation: orientation,
                            safeArea: widget.safeArea,
                            dateRemindList: _currentConfigDR,
                            yearMonthRange: widget.range,
                            onSelectedDate: (pd) => Future.delayed(
                                Duration.zero,
                                () async => setState(() => _cpd = pd)),
                            firstDayOfWeek: widget.firstDayOfWeek,
                            keepPage: true,
                            dayBoxStyle: widget.style.dayBoxStyle,
                            topBarStyle: widget.style.calendarTopBarStyle)),
                    Container(
                        width: MediaQuery.of(context).size.width -
                            (_marginSide * 2),
                        height: (MediaQuery.of(context).size.height / 3.5) -
                            _marginSide,
                        child: Container(
                            constraints: BoxConstraints(
                                maxHeight: orientation == Orientation.portrait
                                    ? MediaQuery.of(context).size.height / 2.5
                                    : double.infinity),
                            child: CupertinoCalendarDateRemindsView(
                              _cpd,
                              dateRemindList: DateRemindList(_currentConfigDR
                                  .where((dr) => (dr is Events)
                                      ? dr.isOngoingDate(_cpd)
                                      : dr.isOngoing(_cpd))
                                  .toList()),
                              dateRemindWidgetStyle:
                                  widget.style.dateRemindWidgetStyle ??
                                      DateRemindWidgetStyle(),
                              onPress: widget
                                  .selectedDateRemindHandlerPreference?.onPress,
                              onLongPress: widget
                                  .selectedDateRemindHandlerPreference
                                  ?.onLongPress,
                            )))
                  ])));
}
