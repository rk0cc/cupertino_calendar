import 'package:intl/intl.dart';

import '../style.dart';
import 'package:cupertino_calendar_structre/structre.dart';
import 'package:cupertino_calendar_structre/structre_tools.dart'
    show DateRemind;
import 'package:flutter/cupertino.dart';

part 'event.dart';
part 'holiday.dart';

/// An event when selected specific [pickedEvent] from the list
typedef SelectDateRemindHandler = void Function(DateRemind pickedEvent);

/// A widget that repersenting one of the [DateRemind] objects
abstract class DateRemindWidget<D extends DateRemind> extends StatelessWidget {
  /// A remind date from [DateRemind]
  final D remind;

  /// An event when pressed once
  final SelectDateRemindHandler? onPressed;

  /// An event when long press
  final SelectDateRemindHandler? onLongPressed;

  final DateRemindWidgetStyle _style;

  /// Locale string for [DateFormat]
  final String? locale;

  /// Create a [Widget] for rendering content of [D]
  DateRemindWidget(this.remind, this.onPressed, this.onLongPressed,
      DateRemindWidgetStyle? style, this.locale)
      : _style = style ?? const DateRemindWidgetStyle();

  /// Generate [BoxDecoration] for [DateRemindWidget]
  BoxDecoration _boxDecoration(BuildContext context);

  /// A [Column]'s children that containing data of [DateRemind]
  List<Widget> _childContent(BuildContext context);

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
          decoration: _boxDecoration(context),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(7.5),
          padding: EdgeInsets.all(10),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _childContent(context))));
}
