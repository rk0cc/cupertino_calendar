import 'package:cupertino_calenar_month_view/src/widgets/widgets.dart'
    show DayBox;
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

class DBRenderWidget extends StatelessWidget {
  final DayBox dayBox;

  DBRenderWidget(this.dayBox);

  @override
  Widget build(BuildContext context) =>
      CupertinoApp(home: CupertinoPageScaffold(child: Center(child: dayBox)));
}

void main() {
  group("Load default style", () {
    testWidgets("in Sunday (unpicked)", (WidgetTester tester) async {
      await tester.pumpWidget(DBRenderWidget(DayBox(
          pickedCondition: (dt) => false,
          isHoliday: (dt) => false,
          hasEvent: (dt) => false,
          day: DateTime(2021, 11, 7))));
      final renderedDB = find.text("7");
      expect(renderedDB, findsOneWidget);
      Text rdbTxt = tester.firstWidget<Text>(renderedDB);
      expect(rdbTxt.style?.color, CupertinoColors.systemRed);
    });
    testWidgets("override theme if holiday", (WidgetTester tester) async {
      await tester.pumpWidget(DBRenderWidget(DayBox(
          pickedCondition: (dt) => false,
          isHoliday: (dt) => true,
          hasEvent: (dt) => false,
          day: DateTime(2021, 11, 11))));
      final renderedDB = find.text("11");
      expect(renderedDB, findsOneWidget);
      Text rdbTxt = tester.firstWidget<Text>(renderedDB);
      expect(rdbTxt.style?.color, CupertinoColors.systemRed);
    });
    testWidgets("Get default saturday", (WidgetTester tester) async {
      await tester.pumpWidget(DBRenderWidget(DayBox(
          pickedCondition: (dt) => false,
          isHoliday: (dt) => false,
          hasEvent: (dt) => false,
          day: DateTime(2021, 11, 6))));
      final renderedDB = find.text("6");
      expect(renderedDB, findsOneWidget);
      Text rdbTxt = tester.firstWidget<Text>(renderedDB);
      expect(rdbTxt.style, null);
    });
  });
}
