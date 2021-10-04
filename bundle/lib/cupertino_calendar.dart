/// A calendar widget designed for [CupertinoApp]
///
/// This library has all basic needed for building calendar in cupertino
library cupertino_calendar;

import 'package:flutter/cupertino.dart' show CupertinoApp;

export 'package:cupertino_calendar_structre/structre.dart';
export 'package:cupertino_calendar_month_view/month_view_module.dart'
    show CalendarTopBarStyle, DayBoxStyle;
export 'package:cupertino_calendar_date_reminds_view/date_reminds_view.dart'
    show DateRemindWidgetStyle;
export 'package:cupertino_calendar_date_reminds_view/module.dart'
    show SelectDateRemindHandler;
export 'src/widget.dart' hide CupertinoCalendarState;
export 'src/style.dart';
export 'src/handlers.dart' hide CupertinoCalendarSelectAction;
