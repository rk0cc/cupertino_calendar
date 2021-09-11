/// A library for displaying [CupertinoCalendarMonthView]
///
/// It is ready to deploy package with customizable style configuration.
///
/// Major function:
/// * Display current month
/// * Set the first day of week
/// * Customize text style for day and backgrround colour
///
/// There is modulize package version for maximize freedom for controlling
/// calendar or just use partical widgets in this package.
library cupertino_calendar_month_view;

import 'src/month_view_widget.dart' show CupertinoCalendarMonthView;

export 'src/month_view_widget.dart' hide CupertinoCalendarMonthViewState;
export 'src/styles/styles.dart';
