import 'package:cupertino_calendar_structre/src/date.dart';
import 'package:test/test.dart';

void main() {
  test("YearMonth compare", () {
    expect(YearMonth(2021, 9).compareTo(YearMonth(2021, 8)), -1);
    expect(YearMonth(2021, 9).compareTo(YearMonth(2020, 8)), -13);
  });
  test("Get a set of YearMonth", () {
    YearMonthRange tymr =
        YearMonthRange(YearMonth(2021, 8), YearMonth(2022, 2));

    expect(tymr.length, 7);
  });
}
