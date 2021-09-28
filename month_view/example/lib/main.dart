import 'package:cupertino_calendar_month_view/month_view.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MonthViewExample());

class MonthViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CupertinoApp(home: DemoHomePage());
}

class DemoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Month view demo")),
      child: MonthViewDemoWidget());
}

// The example start here
class MonthViewDemoWidget extends StatefulWidget {
  // Apply the range of the calendar
  final DateTime demoFrom = DateTime.now().subtract(Duration(days: 90)),
      demoTo = DateTime.now().add(Duration(days: 90));

  @override
  State<MonthViewDemoWidget> createState() => MonthViewDemoWidgetState();
}

class MonthViewDemoWidgetState extends State<MonthViewDemoWidget> {
  @override
  Widget build(BuildContext context) => OrientationBuilder(
      builder: (context, orient) => CupertinoCalendarMonthView.withDateRemind(
          // If the month view is inside another widget, please disable safeArea
          safeArea: true,
          dateRemindList: DateRemindList([
            // Apply date remind objects
            Holiday(
                name: "Sample holiday",
                date: DateTime.now().subtract(Duration(days: 5))),
            AllDayEvents(
                name: "Sample events",
                from: DateTime.now().subtract(Duration(days: 1)),
                to: DateTime.now()),
            Holiday(
                name: "Sample holiday 2",
                date: DateTime.now().add(Duration(days: 3)))
          ]),
          // Assign the range of year month
          yearMonthRange: YearMonthRange(YearMonth.dateTime(widget.demoFrom),
              YearMonth.dateTime(widget.demoTo)),
          orientation: orient));
}
