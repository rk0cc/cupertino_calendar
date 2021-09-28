import 'package:cupertino_calendar_date_reminds_view/src/widgets.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cupertino_calendar_date_reminds_view/module.dart';

import 'mockapp.dart';

void main() {
  test("No non-ongoing date remind appear in the list", () {
    expect(
        () => CupertinoCalendarDateRemindsView(
              DateTime(2021, 9, 5),
              dateRemindList: DateRemindList([
                Holiday(name: "Invalid dr", date: DateTime(2021, 9, 4)),
                Events(
                    name: "Valid dr",
                    from: DateTime(2021, 9, 4, 23, 30),
                    to: DateTime(2021, 9, 5, 0, 45))
              ]),
            ),
        throwsA(isA<AssertionError>()));
  });

  group("Widget render test", () {
    final testMA =
        MockApp(CupertinoCalendarDateRemindsView(DateTime(2021, 9, 15),
            dateRemindList: DateRemindList([
              Events(
                  name: "Ongoing 1",
                  from: DateTime(2021, 9, 14, 23, 30),
                  to: DateTime(2021, 9, 15, 0, 45)),
              Events(
                  name: "Ongoing 2",
                  from: DateTime(2021, 9, 15, 13, 30),
                  to: DateTime(2021, 9, 15, 14, 15)),
              Holiday(name: "Holiday 1", date: DateTime(2021, 9, 15))
            ])));
    testWidgets("Holiday must be listed first", (WidgetTester tester) async {
      await tester.pumpWidget(testMA);

      final drlist = find.descendant(
          of: find.descendant(
              of: find.byType(CupertinoCalendarDateRemindsView),
              matching: find.byType(ListView)),
          matching:
              find.byWidgetPredicate((widget) => widget is DateRemindWidget));
      expect(drlist, findsNWidgets(3));
      expect(
          drlist.evaluate().first.widget.runtimeType, HolidayDateRemindWidget);
    });
    testWidgets("Display duration in default", (WidgetTester tester) async {
      final List<String> expectedOrder = [
        "15 Sep",
        "2021-09-14 23:30 - 2021-09-15 00:45",
        "2021-09-15 13:30 - 2021-09-15 14:15"
      ];

      await tester.pumpWidget(testMA);

      for (String eos in expectedOrder) {
        expect(find.text(eos), findsOneWidget);
      }
    });
  });
}
