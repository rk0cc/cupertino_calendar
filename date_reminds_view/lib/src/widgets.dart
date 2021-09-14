import 'package:cupertino_calendar_structre/structre.dart';
import 'package:cupertino_calendar_structre/structre_tools.dart'
    show DateRemind;
import 'package:flutter/cupertino.dart';

class CupertinoCalendarDateRemindsView extends StatelessWidget {
  final DateTime currentDay;
  final DateRemindList dateRemindList;

  CupertinoCalendarDateRemindsView(this.currentDay,
      {required this.dateRemindList});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

typedef SelectDateRemindHandler = void Function(DateRemind pickedEvent);

abstract class DateRemindWidget extends StatelessWidget {
  final DateRemind remind;
  final SelectDateRemindHandler? onPressed;
  final SelectDateRemindHandler? onLongPressed;

  DateRemindWidget(this.remind, this.onPressed, this.onLongPressed);

  Widget remindContent(BuildContext context);

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        (onPressed ?? (_) {})(remind);
      },
      onLongPress: () {
        (onLongPressed ?? (_) {})(remind);
      },
      child: remindContent(context));
}

class HolidayDateRemindWidget extends DateRemindWidget {
  HolidayDateRemindWidget(Holiday remind,
      {SelectDateRemindHandler? onPressed,
      SelectDateRemindHandler? onLongPressed})
      : super(remind, onPressed, onLongPressed);

  @override
  Widget remindContent(BuildContext context) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            // TODO: Get colour from style
            border: Border.all(color: CupertinoColors.systemRed)),
      );
}
