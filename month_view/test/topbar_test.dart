import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cupertino_calendar_month_view/src/widgets/widgets.dart'
    show CalendarTopBar;
import 'package:cupertino_calendar_month_view/src/styles/styles.dart'
    show CalendarTopBarStyle, MonthApperance;

import 'mockapp.dart';

class TopBarTestContainer extends StatefulWidget {
  final YearMonthRange range =
      YearMonthRange(YearMonth(2021, 7), YearMonth(2021, 12));
  @override
  State<TopBarTestContainer> createState() => TopBarTestContainerState();
}

class TopBarTestContainerState extends State<TopBarTestContainer> {
  late YearMonth curretnYearMonth;
  @override
  void initState() {
    /// This must be currrent month
    curretnYearMonth = YearMonth(2021, 9);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        child: CalendarTopBar(
          style:
              CalendarTopBarStyle(yearMonthFormat: MonthApperance.short_name),
          yearMonth: curretnYearMonth,
          range: widget.range,
          onPrevious: () {
            setState(() {
              var yml = widget.range.toList();
              curretnYearMonth = yml[
                  yml.indexWhere((element) => element == curretnYearMonth) - 1];
            });
          },
          onNext: () {
            setState(() {
              var yml = widget.range.toList();
              curretnYearMonth = yml[
                  yml.indexWhere((element) => element == curretnYearMonth) + 1];
            });
          },
        ),
      );
}

void main() {
  testWidgets("Check default date format pattern", (WidgetTester tester) async {
    var currentMonthStr = YearMonth(2021, 9).formatString(format: "MMM, yyyy");
    expect(currentMonthStr, "Sep, 2021");
    await tester.pumpWidget(MockApp(TopBarTestContainer()));
    expect(find.text(currentMonthStr), findsOneWidget);
  });
  group("Mock press to previous month", () {
    var julyStr = YearMonth(2021, 7).formatString(format: "MMM, yyyy");
    test("check is valid July format", () => expect(julyStr, "Jul, 2021"));
    testWidgets("to July", (WidgetTester tester) async {
      await tester.pumpWidget(MockApp(TopBarTestContainer()));
      final previousBtn = find.byIcon(CupertinoIcons.left_chevron);
      for (int p = 0; p < 2; p++) {
        await tester.tap(previousBtn);
      }
      await tester.pump();
      expect(find.text(julyStr), findsOneWidget);
    });
    testWidgets("no change after reach July", (WidgetTester tester) async {
      await tester.pumpWidget(MockApp(TopBarTestContainer()));
      final previousBtn = find.byIcon(CupertinoIcons.left_chevron);
      for (int p = 0; p < 3; p++) {
        await tester.tap(previousBtn);

        // Keep update it to ensure the button will be disabled when reached July
        await tester.pump();
      }
      expect(find.text(julyStr), findsOneWidget);
    });
  });
  group("Mock press to next Month", () {
    var novemberStr = YearMonth(2021, 11).formatString(format: "MMM, yyyy");
    test("check is valid Novenber format",
        () => expect(novemberStr, "Nov, 2021"));
    testWidgets("to November", (WidgetTester tester) async {
      await tester.pumpWidget(MockApp(TopBarTestContainer()));
      final nextBtn = find.byIcon(CupertinoIcons.right_chevron);
      for (int p = 0; p < 2; p++) {
        await tester.tap(nextBtn);
      }
      await tester.pump();
      expect(find.text(novemberStr), findsOneWidget);
    });
    testWidgets("no change after reach December", (WidgetTester tester) async {
      await tester.pumpWidget(MockApp(TopBarTestContainer()));
      final nextBtn = find.byIcon(CupertinoIcons.right_chevron);
      for (int p = 0; p < 4; p++) {
        await tester.tap(nextBtn);

        // Keep update it to ensure the button will be disabled when reached July
        await tester.pump();
      }
      expect(find.text(YearMonth(2021, 12).formatString(format: "MMM, yyyy")),
          findsOneWidget);
    });
  });
}
