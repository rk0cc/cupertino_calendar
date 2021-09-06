import 'package:cupertino_calendar_structre/src/date.dart';
import 'package:cupertino_calendar_structre/src/week.dart';
import 'package:test/test.dart';

void main() {
  group("Get placeholder count", () {
    test("from start", () {
      Map<YearMonth, Map<FirstDayOfWeek, int>> startTesterCombination = {
        YearMonth(2021, 9): {
          FirstDayOfWeek.sat: 4,
          FirstDayOfWeek.sun: 3,
          FirstDayOfWeek.mon: 2
        },
        YearMonth(2021, 8): {
          FirstDayOfWeek.sat: 1,
          FirstDayOfWeek.sun: 0,
          FirstDayOfWeek.mon: 6
        },
        YearMonth(2021, 7): {
          FirstDayOfWeek.sat: 5,
          FirstDayOfWeek.sun: 4,
          FirstDayOfWeek.mon: 3
        }
      };
      startTesterCombination.forEach((ym, phc) {
        phc.forEach((fdw, ph) {
          try {
            expect(fdw.calculatePlaceholderFromStart(ym), ph);
          } on TestFailure catch (tf) {
            print(
                "\x1B[31mIncorrect value on ${ym.year} - ${ym.month} at ${fdw.toString()}\x1B[0m");
            throw tf;
          }
        });
      });
    });
    test("from end", () {
      Map<YearMonth, Map<FirstDayOfWeek, int>> endTesterCombination = {
        YearMonth(2021, 9): {
          FirstDayOfWeek.sat: 1,
          FirstDayOfWeek.sun: 2,
          FirstDayOfWeek.mon: 3
        },
        YearMonth(2021, 8): {
          FirstDayOfWeek.sat: 3,
          FirstDayOfWeek.sun: 4,
          FirstDayOfWeek.mon: 5
        },
        YearMonth(2021, 7): {
          FirstDayOfWeek.sat: 6,
          FirstDayOfWeek.sun: 0,
          FirstDayOfWeek.mon: 1
        }
      };
      endTesterCombination.forEach((ym, phc) {
        phc.forEach((fdw, ph) {
          try {
            expect(fdw.calculatePlaceholderFromEnd(ym), ph);
          } on TestFailure catch (tf) {
            print(
                "\x1B[31mIncorrect value on ${ym.year} - ${ym.month} at ${fdw.toString()}\x1B[0m");
            throw tf;
          }
        });
      });
    });
  });
}
