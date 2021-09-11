import 'package:cupertino_calendar_structre/src/reminds.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

class ThirdPartyEventsData with DateRemindGenerator<Events> {
  final String start = "2019-09-01 08:00:00";
  final String end = "2019-09-01 09:00:00";
  final String name = "First lesson";

  static DateTime loadFormat(String se) =>
      DateFormat("yyyy-MM-dd HH:mm:ss").parse(se);

  @override
  Events get remindObject =>
      Events(name: name, from: loadFormat(start), to: loadFormat(end));
}

class ThirdPartyEvents {
  final String eventName;
  final String from;
  final String to;

  ThirdPartyEvents(
      {required this.eventName, required this.from, required this.to});
}

class ThirdPartyHoliday {
  final String holidayName;
  final String date;

  ThirdPartyHoliday({required this.holidayName, required this.date});
}

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
  group("Generator test", () {
    test("get events", () {
      expect(ThirdPartyEventsData().remindObject.from,
          DateTime(2019, 9, 1, 8, 0, 0));
    });
  });
  group("DateRemindList test", () {
    List<ThirdPartyEvents> _dummyE = [
      ThirdPartyEvents(
          eventName: "Foo",
          from: "2020-01-01 09:00:00",
          to: "2020-01-01 09:03:00"),
      ThirdPartyEvents(
          eventName: "Foo 2",
          from: "2020-01-02 09:00:00",
          to: "2020-01-02 09:03:00"),
      ThirdPartyEvents(
          eventName: "Foo 3",
          from: "2020-01-03 09:00:00",
          to: "2020-01-03 09:03:00")
    ];
    List<ThirdPartyHoliday> _dummyH = [
      ThirdPartyHoliday(holidayName: "Bar 1", date: "2019-08-09"),
      ThirdPartyHoliday(holidayName: "Bar 2", date: "2019-11-21")
    ];
    test("sperate test", () {
      DateRemindList speratedList = DateRemindListConversion
          .convertListFromDividedSource<ThirdPartyEvents, ThirdPartyHoliday>(
              _dummyE, _dummyH,
              exportEvents: (de) => Events(
                  name: de.eventName,
                  from: ThirdPartyEventsData.loadFormat(de.from),
                  to: ThirdPartyEventsData.loadFormat(de.to)),
              exportHoliday: (dh) => Holiday(
                  name: dh.holidayName,
                  date: DateFormat("yyyy-MM-dd").parse(dh.date)));
      expect(speratedList.events.length, 3);
      expect(speratedList.holiday.length, 2);
      expect(
          () => speratedList.singleWhere((element) => element.name == "Foo 2"),
          returnsNormally);
    });
    test("all in one list", () {
      DateRemindList aiol =
          DateRemindListConversion.convertListFromSource<dynamic>(
              []
                ..addAll(_dummyE)
                ..addAll(_dummyH),
              eventsCondition: (i) => i is ThirdPartyEvents,
              holidayCondition: (i) => i is ThirdPartyHoliday,
              exportEvents: (de) => Events(
                  name: de.eventName,
                  from: ThirdPartyEventsData.loadFormat(de.from),
                  to: ThirdPartyEventsData.loadFormat(de.to)),
              exportHoliday: (dh) => Holiday(
                  name: dh.holidayName,
                  date: DateFormat("yyyy-MM-dd").parse(dh.date)));
      expect(aiol.events.length, 3);
      expect(aiol.holiday.length, 2);
      expect(() => aiol.singleWhere((element) => element.name == "Foo 2"),
          returnsNormally);
    });
  });
}
