import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cupertino_calendar_date_reminds_view/module.dart';

import 'mockapp.dart';

void main() {
  testWidgets("Test apply holiday", (WidgetTester tester) async {
    await tester.pumpWidget(MockApp(Center(
        child: HolidayDateRemindWidget(
            Holiday(name: "Sample holiday", date: DateTime(2021, 7, 15))))));
    final renderRes = find.byType(HolidayDateRemindWidget);
    expect(renderRes, findsOneWidget);
    expect(
        (find
                .descendant(of: renderRes, matching: find.byType(Column))
                .evaluate()
                .single
                .widget as Column)
            .children
            .length,
        2);
    expect(
        (find
                .descendant(
                    of: renderRes, matching: find.text("Sample holiday"))
                .evaluate()
                .single
                .widget as Text)
            .style
            ?.fontSize,
        28);
  });
}
