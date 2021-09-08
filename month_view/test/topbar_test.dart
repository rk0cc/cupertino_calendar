import 'package:cupertino_calendar_structre/cupertino_calendar_structre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cupertino_calenar_month_view/src/widgets/widgets.dart'
    show CalendarTopBar;
import 'package:cupertino_calenar_month_view/src/styles/styles.dart'
    show CalendarTopBarStyle, MonthApperance;

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

class MockHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      CupertinoPageScaffold(child: TopBarTestContainer());
}

CupertinoApp mockApp = CupertinoApp(home: MockHomePage());

void main() {
  testWidgets("Check default date format pattern", (WidgetTester tester) async {
    var currentMonthStr = YearMonth(2021, 9).formatString(format: "MMM, yyyy");
    expect(currentMonthStr, "Sep, 2021");
    await tester.pumpWidget(mockApp);
    expect(find.text(currentMonthStr), findsOneWidget);
  });
  group("Mock press to previous month", () {
    var julyStr = YearMonth(2021, 7).formatString(format: "MMM, yyyy");
    testWidgets("Mock pressing previous month to July",
        (WidgetTester tester) async {
      expect(julyStr, "Jul, 2021");
      await tester.pumpWidget(mockApp);
      final previousBtn = find.byIcon(CupertinoIcons.left_chevron);
      for (int p = 0; p < 2; p++) {
        await tester.tap(previousBtn);
      }
      await tester.pump();
      expect(find.text(julyStr), findsOneWidget);
    });
    testWidgets("No addition change when reached July",
        (WidgetTester tester) async {
      expect(julyStr, "Jul, 2021");
      await tester.pumpWidget(mockApp);
      final previousBtn = find.byIcon(CupertinoIcons.left_chevron);
      for (int p = 0; p < 2; p++) {
        await tester.tap(previousBtn);
      }
      await tester.pump();
      expect(find.text(julyStr), findsOneWidget);
    });
  });
}
