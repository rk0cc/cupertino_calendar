import 'package:flutter/cupertino.dart';
import 'package:cupertino_calendar/cupertino_calendar.dart';

void main() => runApp(CupertinoCalendarExample());

class CupertinoCalendarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      CupertinoApp(home: CupertinoCalendarIndex());
}

class CupertinoCalendarIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CupertinoCalendarIndex();
}

class _CupertinoCalendarIndex extends State<CupertinoCalendarIndex> {
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: CupertinoCalendar(
          YearMonthRange(
              YearMonth.dateTime(DateTime.now().subtract(Duration(days: 120))),
              YearMonth.dateTime(DateTime.now().add(Duration(days: 120)))),
          dateReminds: DateRemindList([
            Holiday(
                name: "Sample holiday",
                date: DateTime.now().add(Duration(days: 2))),
            Events(
                name: "Sample event",
                from: DateTime.now().add(Duration(hours: 2)),
                to: DateTime.now().add(Duration(hours: 3))),
            Events(
                name: "Sample event 2",
                from: DateTime.now().add(Duration(days: 2)),
                to: DateTime.now().add(Duration(days: 2, hours: 1)))
          ])));
}
