import 'dateremind/dateremind.dart';
import 'style.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:cupertino_calendar_structre/structre_tools.dart'
    show DateRemind;
import 'package:flutter/cupertino.dart';

class CupertinoCalendarDateRemindsView extends StatelessWidget {
  final DateTime currentDay;
  final List<DateRemind> _drl;
  final DateRemindWidgetStyle dateRemindWidgetStyle;
  final SelectDateRemindHandler? onPress;
  final SelectDateRemindHandler? onLongPress;
  final String? locale;

  CupertinoCalendarDateRemindsView(this.currentDay,
      {required DateRemindList dateRemindList,
      this.dateRemindWidgetStyle = const DateRemindWidgetStyle(),
      this.onPress,
      this.onLongPress,
      this.locale})
      : assert(dateRemindList.where((dr) => !dr.isOngoing(currentDay)).isEmpty,
            "Ensure all date reminds are ongoing"),
        _drl = []
          ..addAll(dateRemindList.holiday)
          ..addAll(dateRemindList.events);

  @override
  Widget build(BuildContext context) => ListView.builder(
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
