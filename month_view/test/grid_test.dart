import 'dart:math';

import 'package:cupertino_calendar_month_view/src/widgets/widgets.dart'
    show MonthGrid, DayBox;
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mockapp.dart';

void main() {
  var tym = YearMonth(2021, 9);
  group("Assertion test", () {
    test("disallow outranged holiday", () {
      expect(
          () => MonthGrid(tym, currentDatePickedEvent: (cd) {}, holiday: [
                Holiday(name: "Valid 1", date: DateTime(2021, 8, 15)),
                Holiday(name: "Valid 2", date: DateTime(2021, 9, 15)),
                Holiday(name: "Valid 3", date: DateTime(2021, 10, 15))
              ]),
          returnsNormally);
      expect(
          () => MonthGrid(tym, currentDatePickedEvent: (cd) {}, holiday: [
                Holiday(name: "Invalid 1", date: DateTime(2021, 7, 15)),
                Holiday(name: "Valid 2", date: DateTime(2021, 9, 15)),
                Holiday(name: "Valid 3", date: DateTime(2021, 10, 15))
              ]),
          throwsA(isAssertionError));
    });
    test("disallow outranged events", () {
      expect(
          () => MonthGrid(tym, currentDatePickedEvent: (cd) {}, events: [
                Events(
                    name: "Valid 1",
                    from: DateTime(2021, 8, 30, 15, 30, 0),
                    to: DateTime(2021, 8, 30, 15, 45, 0)),
                Events(
                    name: "Valid 2",
                    from: DateTime(2021, 8, 30, 15, 30, 0),
                    to: DateTime(2021, 9, 2, 15, 45, 0)),
                Events(
                    name: "Valid 3",
                    from: DateTime(2021, 9, 30, 15, 30, 0),
                    to: DateTime(2021, 10, 5, 15, 45, 0)),
                Events(
                    name: "Valid 4",
                    from: DateTime(2021, 7, 30, 15, 30, 0),
                    to: DateTime(2021, 11, 5, 15, 45, 0)),
                Events(
                    name: "Valid 5",
                    from: DateTime(2021, 7, 30, 15, 30, 0),
                    to: DateTime(2021, 8, 5, 15, 45, 0)),
                Events(
                    name: "Valid 6",
                    from: DateTime(2021, 9, 30, 15, 30, 0),
                    to: DateTime(2021, 11, 5, 15, 45, 0))
              ]),
          returnsNormally);
      expect(
          () => MonthGrid(tym, currentDatePickedEvent: (cd) {}, events: [
                Events(
                    name: "Valid 1",
                    from: DateTime(2021, 8, 30, 15, 30, 0),
                    to: DateTime(2021, 8, 30, 15, 45, 0)),
                Events(
                    name: "Valid 2",
                    from: DateTime(2021, 8, 30, 15, 30, 0),
                    to: DateTime(2021, 9, 2, 15, 45, 0)),
                Events(
                    name: "Invalid 3",
                    from: DateTime(2021, 11, 2, 15, 30, 0),
                    to: DateTime(2021, 11, 5, 15, 45, 0))
              ]),
          throwsA(isAssertionError));
    });
  });
  group("Widget test", () {
    var mA = MockApp(Container(
        width: 300,
        height: 600,
        child: MonthGrid(tym, currentDatePickedEvent: (cd) {})));
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
