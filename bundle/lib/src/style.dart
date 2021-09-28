import 'package:flutter/cupertino.dart';

import 'package:cupertino_calendar_month_view/month_view.dart'
    show CalendarTopBarStyle, DayBoxStyle;
import 'package:cupertino_calendar_date_reminds_view/date_reminds_view.dart'
    hide CupertinoCalendarDateRemindsView;

@immutable
class CupertinoCalendarStyle {
  final CalendarTopBarStyle? calendarTopBarStyle;
  final DayBoxStyle dayBoxStyle;
  final DateRemindWidgetStyle? dateRemindWidgetStyle;

  const CupertinoCalendarStyle(
      {this.calendarTopBarStyle,
      this.dayBoxStyle = const DayBoxStyle(landscapeWidthRatio: 1),
      this.dateRemindWidgetStyle});
}
