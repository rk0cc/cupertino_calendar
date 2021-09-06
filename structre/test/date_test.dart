import 'package:cupertino_calendar_structre/cupertino_calendar_structre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("YearMonth compare", () {
    expect(YearMonth(2021, 9).compareTo(YearMonth(2021, 8)), -1);
    expect(YearMonth(2021, 9).compareTo(YearMonth(2020, 8)), -13);
  });
}
