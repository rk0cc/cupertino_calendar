import 'widget.dart' show CupertinoCalendar;
import 'package:flutter/cupertino.dart';
import 'package:cupertino_calendar_month_view/month_view.dart'
    show CalendarTopBarStyle, DayBoxStyle;
import 'package:cupertino_calendar_month_view/month_view_module.dart'
    show CalendarTopBar, DayBox;
import 'package:cupertino_calendar_date_reminds_view/date_reminds_view.dart'
    hide CupertinoCalendarDateRemindsView;
import 'package:cupertino_calendar_date_reminds_view/module.dart'
    show DateRemindWidget;

/// Assign style for [CupertinoCalendar] and override system's preference
@immutable
class CupertinoCalendarStyle {
  /// Style preference for [CalendarTopBar]
  final CalendarTopBarStyle calendarTopBarStyle;

  /// Style preference for [DayBox]
  final DayBoxStyle dayBoxStyle;

  /// Style preference for [DateRemindWidget]
  final DateRemindWidgetStyle dateRemindWidgetStyle;

  /// Assign preferences of [CupertinoCalendar] style
  const CupertinoCalendarStyle(
      {this.calendarTopBarStyle = const CalendarTopBarStyle(),
      this.dayBoxStyle = const DayBoxStyle(landscapeWidthRatio: 1),
      this.dateRemindWidgetStyle = const DateRemindWidgetStyle()});
}
