import 'package:flutter/cupertino.dart';

class MockApp extends StatelessWidget {
  final Widget testWidget;

  MockApp(this.testWidget);

  @override
  Widget build(BuildContext context) =>
      CupertinoApp(home: CupertinoPageScaffold(child: testWidget));
}
