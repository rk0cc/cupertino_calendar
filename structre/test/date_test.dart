import 'package:cupertino_calendar_structre/src/date.dart';
import 'package:test/test.dart';

void main() {
  test("YearMonth compare", () {
    expect(YearMonth(2021, 9).compareTo(YearMonth(2021, 8)), -1);
    expect(YearMonth(2021, 9).compareTo(YearMonth(2020, 8)), -13);
    expect(YearMonth(2021, 9).compareTo(YearMonth(2021, 12)), 3);
    expect(YearMonth(2021, 9).compareTo(YearMonth(2023, 3)), 18);
  });
  test("Get a set of YearMonth", () {
    YearMonth f = YearMonth(2021, 8), t = YearMonth(2022, 2);
    YearMonthRange tymr = YearMonthRange(f, t);
    expect(tymr.length, f.compareTo(t) + 1);
  });
  test("Day generated from YearMonth", () {
    expect(YearMonth(2021, 8).allDaysInMonth.length, 31);
    expect(YearMonth(2020, 2).allDaysInMonth.length, 29);
    expect(YearMonth(2021, 2).allDaysInMonth.length, 28);
  });
  test("Get now YearMonth", () {
    DateTime today = DateTime.now();
    YearMonth tM = YearMonth.now();
    expect(tM.year, today.year);
    expect(tM.month, today.month);
  });
  group("Range test", () {
    var f = YearMonth(2021, 3), t = YearMonth(2021, 8);
    YearMonthRange testRange = YearMonthRange(f, t);
    test("check sort order", () {
      expect(testRange.toList().first, equals(f));
      expect(testRange.toList().last, equals(t));
    });
    test("get corrected index", () {
      expect(testRange.indexWhere(f), 0);
      expect(testRange.indexWhere(t), testRange.length - 1);
      expect(testRange.indexWhere(YearMonth(2021, 5)), 2);
    });
  });
}
