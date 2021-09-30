import 'dateremind/dateremind.dart';
import 'style.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:cupertino_calendar_structre/structre_tools.dart'
    show DateRemind;
import 'package:flutter/cupertino.dart';

/// A completed [Widget] for listing all [DateRemind] data
///
/// P.S. This [Widget] is a [StatelessWidget], please wrap it in a [State]
/// and provide current state's [currentDay]
class CupertinoCalendarDateRemindsView extends StatelessWidget {
  /// Current day of listing [DateRemind] in [CupertinoCalendarDateRemindsView]
  final DateTime currentDay;
  final List<DateRemind> _drl;

  /// Style data for [DateRemindWidget]
  final DateRemindWidgetStyle dateRemindWidgetStyle;

  /// Handler when pressed [DateRemindWidget]
  final SelectDateRemindHandler? onPress;

  /// Handler when long pressed [DateRemindWidget]
  final SelectDateRemindHandler? onLongPress;

  /// Locale string for [DateFormat]
  final String? locale;

  /// Create a [Widget] for listing [DateRemind] from [dateRemindList]
  ///
  /// Throws [AssertionError] if found non-ongoing [DateRemind] in [dateRemindList]
  CupertinoCalendarDateRemindsView(this.currentDay,
      {required DateRemindList dateRemindList,
      this.dateRemindWidgetStyle = const DateRemindWidgetStyle(),
      this.onPress,
      this.onLongPress,
      this.locale})
      : assert(
            dateRemindList
                .where((dr) => !((dr is Events)
                    ? dr.isOngoingDate(currentDay)
                    : dr.isOngoing(currentDay)))
                .isEmpty,
            "Ensure all date reminds are ongoing"),
        _drl = []
          ..addAll(dateRemindList.holiday)
          ..addAll(dateRemindList.events);

  @override
  Widget build(BuildContext context) => ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _drl.length,
      itemBuilder: (context, count) => (<DateRemindWidget>(DateRemind dr) {
            switch (dr.runtimeType) {
              case Holiday:
                return HolidayDateRemindWidget(dr as Holiday,
                    style: dateRemindWidgetStyle,
                    onPressed: onPress,
                    onLongPressed: onLongPress,
                    locale: locale);
              case Events:
              case AllDayEvents:
                return EventsDateRemindWidget(dr as Events,
                    style: dateRemindWidgetStyle,
                    onPressed: onPress,
                    onLongPressed: onLongPress,
                    locale: locale);
              default:
                throw UnimplementedError(
                    "${dr.runtimeType.toString()} is not supported for native Cupertino Calendar Date Reminds View yet");
            }
          })(_drl[count]));
}
