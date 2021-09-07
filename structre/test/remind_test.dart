import 'package:cupertino_calendar_structre/src/reminds.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  group("Object definition", () {
    group("in Events", () {
      test("block invalid assign", () {
        expect(
            () => Events(
                name: "Invalid event 1",
                from: DateTime(2021, 1, 1, 15, 0, 0),
                to: DateTime(2020, 9, 1, 8, 5, 0)),
            throwsA(isA<AssertionError>()));
      });
      group("crawl value", () {
        test("events", () {
          DateTime df = DateTime(2021, 8, 1, 13, 0, 0),
              dt = DateTime(2021, 8, 1, 14, 0, 0);
          Events e = Events(name: "Sample event", from: df, to: dt);
          expect(e.json, {
            "events": {
              "name": "Sample event",
              "description": null,
              "duration": {
                "from": DateFormat("yyyy-MM-dd HH:mm:ss").format(df),
                "to": DateFormat("yyyy-MM-dd HH:mm:ss").format(dt)
              }
            }
          });
        });
        test("full day events", () {
          AllDayEvents ade = AllDayEvents(
              name: "Sample all day",
              from: DateTime(2021, 9, 1, 15, 30, 10),
              to: DateTime(2021, 9, 1));
          expect(ade.from, DateTime(2021, 9, 1, 0, 0, 0));
          expect(ade.to, DateTime(2021, 9, 1, 23, 59, 59));
        });
      });
      test("ongoing condition", () {
        Events oge = Events(
            name: "Ongoing event",
            from: DateTime.now().subtract(Duration(hours: 1)),
            to: DateTime.now().add(Duration(hours: 1)));
        expect(oge.isOngoing(DateTime.now()), true);
      });
    });
    test("in holiday", () {
      Holiday xmas = Holiday(name: "Christmas", date: DateTime(2020, 12, 25));
      expect(xmas.json, {
        "holiday": {
          "name": "Christmas",
          "date": DateFormat("yyy-MM-dd").format(xmas.dateTime)
        }
      });
    });
  });
}
