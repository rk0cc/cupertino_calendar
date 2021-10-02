import 'package:flutter/cupertino.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:cupertino_calendar_date_reminds_view/date_reminds_view.dart';

void main() => runApp(DateRemindViewExample());

class DateRemindViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      CupertinoApp(home: DateRemindViewIndex());
}

class DateRemindViewIndex extends StatefulWidget {
  // You can add extra event or holiday here for demo
  final edrl = [
    Events(
        name: "Sample event 1",
        from: DateTime(2021, 9, 3, 9),
        to: DateTime(2021, 9, 3, 11)),
    AllDayEvents(
        name: "Sample event 2",
        from: DateTime(2021, 9, 15),
        to: DateTime(2021, 9, 18)),
    Events(
        name: "Sample event 3",
        from: DateTime(2021, 9, 3, 10),
        to: DateTime(2021, 9, 3, 11)),
    Events(
        name: "Sample event 4",
        description: "It appear under holiday",
        from: DateTime(2021, 9, 1, 13, 30),
        to: DateTime(2021, 9, 1, 14)),
    Holiday(name: "First day of school", date: DateTime(2021, 9, 1))
  ];
  @override
  State<DateRemindViewIndex> createState() => _DateRemindViewIndex();
}

class _DateRemindViewIndex extends State<DateRemindViewIndex> {
  late DateTime currentDate;

  @override
  void initState() {
    currentDate = DateTime(2021, 9, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Date reminds view demo"),
        backgroundColor: CupertinoColors.lightBackgroundGray,
      ),
      child: SafeArea(
          child: Center(
              child: Container(
                  margin: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    Text(
                        "Current date: ${currentDate.year} - ${currentDate.month} - ${currentDate.day}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w400)),
                    Container(
                        width: MediaQuery.of(context).size.width - 10,
                        child: CupertinoButton(
                            child: Text("Change date"),
                            onPressed: () => showCupertinoModalPopup(
                                context: context,
                                builder: (context) => Container(
                                    height: 500,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    child: Column(children: [
                                      Container(
                                          height: 400,
                                          child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              initialDateTime: currentDate,
                                              minimumYear: 2021,
                                              maximumYear: 2021,
                                              onDateTimeChanged: (val) {
                                                setState(
                                                    () => currentDate = val);
                                              })),
                                      CupertinoButton(
                                          child: Text('OK'),
                                          onPressed: () =>
                                              Navigator.of(context).pop())
                                    ]))))),
                    Expanded(
                        child: CupertinoCalendarDateRemindsView(currentDate,
                            dateRemindList: DateRemindList(widget.edrl
                                .where((dr) => dr.isOngoing(currentDate))
                                .toList()),
                            onPress: (picked) => showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                      content: Text(picked.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24)),
                                      actions: [
                                        CupertinoButton(
                                            child: Text("Close"),
                                            onPressed: () =>
                                                Navigator.pop(context))
                                      ],
                                    ))))
                  ])))));
}
