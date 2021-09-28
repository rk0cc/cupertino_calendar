import 'package:cupertino_calendar_structre/structre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cupertino_calendar_date_reminds_view/module.dart';

import 'mockapp.dart';

void main() {
  testWidgets("Test appply event", (WidgetTester tester) async {
    await tester.pumpWidget(MockApp(Center(
        child: EventsDateRemindWidget(Events(
            name: "Date remind test",
            from: DateTime(2021, 9, 1, 10),
            to: DateTime(2021, 9, 1, 11))))));

    final renderRes = find.byType(EventsDateRemindWidget);
    expect(renderRes, findsOneWidget);
    expect(
        (find
                .descendant(of: renderRes, matching: find.byType(Column))
                .evaluate()
                .single
                .widget as Column)
            .children
            .length,
        3);
    expect(
        (find
                .descendant(
                    of: renderRes, matching: find.text("Date remind test"))
                .evaluate()
                .single
                .widget as Text)
            .style
            ?.fontSize,
        28);
  });
}
