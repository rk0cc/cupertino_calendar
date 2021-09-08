import 'package:cupertino_calenar_month_view/src/widgets/widgets.dart'
    show MonthGrid, MonthGridState;
import 'package:cupertino_calendar_structre/cupertino_calendar_structre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Applying events and holidays", () {
    var tym = YearMonth(2021, 9);
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
}
