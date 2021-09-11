import 'dart:math';

import 'package:cupertino_calendar_month_view/src/widgets/widgets.dart'
    show MonthGrid, DayBox;
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mockapp.dart';

void main() {
  var tym = YearMonth(2021, 9);
  group("Applying events and holidays", () {
    test("only allow holiday in current year and month", () {
      expect(
          () => MonthGrid(tym, holidayInThisMonth: [
                Holiday(name: "Christmas", date: DateTime(2021, 12, 25))
              ]),
          throwsA(isA<AssertionError>()));
      expect(
          () => MonthGrid(tym, holidayInThisMonth: [
                Holiday(name: "First day of school", date: DateTime(2021, 9, 1))
              ]),
          returnsNormally);
    });
    test("only allow events which still effect", () {
      List<Events> te = [
        Events(
            name: "Sample event 1",
            from: DateTime(2021, 8, 25, 13, 0, 0),
            to: DateTime(2021, 10, 5, 8, 0, 0)),
        Events(
            name: "Sample event 2",
            from: DateTime(2021, 9, 1, 0, 0, 0),
            to: DateTime(2021, 9, 1, 1, 0, 0)),
        AllDayEvents(
            name: "Sample all day event",
            from: DateTime(2021, 8, 29),
            to: DateTime(2021, 9, 7))
      ];
      expect(() => MonthGrid(tym, eventsInThisMonth: te), returnsNormally);
      Events invalidEvent = Events(
          name: "Invalid event",
          from: DateTime(2020, 11, 4, 15, 40, 9),
          to: DateTime(2020, 12, 6, 9, 30, 15));
      expect(() => MonthGrid(tym, eventsInThisMonth: te..add(invalidEvent)),
          throwsA(isA<AssertionError>()));
      expect(
          () => MonthGrid(tym,
              eventsInThisMonth: te
                ..remove(invalidEvent)
                ..add(AllDayEvents(
                    name: "Invalid ADE",
                    from: DateTime(2021, 10, 5),
                    to: DateTime(2021, 10, 15)))),
          throwsA(isA<AssertionError>()));
    });
  });
  group("Widget test", () {
    var mA = MockApp(Container(width: 300, height: 600, child: MonthGrid(tym)));
    var today = DateTime.now();
    print(
        "Today is ${today.year}-${today.month}-${today.day},\nit will not be used as the day of tapping test");
    int todayIntD = today.day;
    testWidgets("find highlighted day", (WidgetTester tester) async {
      final String todayDay = todayIntD.toString();
      await tester.pumpWidget(mA);
      final todayDBWidget = find.text(todayDay, skipOffstage: false);
      expect(todayDBWidget, findsOneWidget);
      final dbContainers =
          find.ancestor(of: todayDBWidget, matching: find.byType(DayBox));
      expect(dbContainers, findsOneWidget);
      await tester.pump();
      expect(
          (tester
                  .widget<Container>(find.descendant(
                      of: dbContainers, matching: find.byType(Container)))
                  .decoration as BoxDecoration)
              .color,
          CupertinoColors.activeBlue);
    });
    testWidgets("tap another day", (WidgetTester tester) async {
      Random random = Random();
      await tester.pumpWidget(mA);
      final aDIM = tym.allDaysInMonth;
      late DateTime targetTap;
      do {
        targetTap = aDIM.elementAt(random.nextInt(aDIM.length));
      } while (targetTap.day == todayIntD);
      print(
          "Target tapping day: ${targetTap.year}-${targetTap.month}-${targetTap.day}");
      final preferedTapDayBox = find.ancestor(
          of: find.text(targetTap.day.toString()),
          matching: find.byType(DayBox));
      expect(preferedTapDayBox, findsOneWidget);
      await tester.tap(preferedTapDayBox);
      await tester.pump();
      expect(
          (tester
                  .widget<Container>(find.descendant(
                      of: preferedTapDayBox, matching: find.byType(Container)))
                  .decoration as BoxDecoration)
              .color,
          CupertinoColors.activeBlue);
    });
  });
}
