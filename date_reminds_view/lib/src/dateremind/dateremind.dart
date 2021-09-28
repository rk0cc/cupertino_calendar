import 'package:intl/intl.dart';

import '../style.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:cupertino_calendar_structre/structre_tools.dart'
    show DateRemind;
import 'package:flutter/cupertino.dart';

part 'event.dart';
part 'holiday.dart';

typedef SelectDateRemindHandler = void Function(DateRemind pickedEvent);

abstract class DateRemindWidget<D extends DateRemind> extends StatelessWidget {
  final D remind;
  final SelectDateRemindHandler? onPressed;
  final SelectDateRemindHandler? onLongPressed;
  final DateRemindWidgetStyle _style;
  final String? locale;

  DateRemindWidget(this.remind, this.onPressed, this.onLongPressed,
      DateRemindWidgetStyle? style, this.locale)
      : _style = style ?? const DateRemindWidgetStyle();

  BoxDecoration boxDecoration(BuildContext context);

  List<Widget> childContent(BuildContext context);

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        (onPressed ?? (_) {})(remind);
      },
      onLongPress: () {
        (onLongPressed ?? (_) {})(remind);
      },
      child: Container(
          alignment: Alignment.topLeft,
          decoration: boxDecoration(context),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(7.5),
          padding: EdgeInsets.all(10),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: childContent(context))));
}
