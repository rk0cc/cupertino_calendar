part of 'dateremind.dart';

class HolidayDateRemindWidget extends DateRemindWidget<Holiday> {
  HolidayDateRemindWidget(Holiday holiday,
      {SelectDateRemindHandler? onPressed,
      SelectDateRemindHandler? onLongPressed,
      DateRemindWidgetStyle? style,
      String? locale})
      : super(holiday, onPressed, onLongPressed, style, locale);

  @override
  BoxDecoration boxDecoration(BuildContext context) => BoxDecoration(
        borderRadius: BorderRadius.all(_style.borderRadius),
        border: Border.all(color: _style.holidayBorderColour),
        color: _style.backgroundColour,
      );

  @override
  List<Widget> childContent(BuildContext context) => [
        Padding(
            padding: EdgeInsets.only(bottom: 2.5),
            child: Text(remind.name,
                style: _style.titleStyle, textAlign: TextAlign.start)),
        Text(
            (locale == null ? DateFormat("MMM d") : DateFormat.MMMd(locale))
                .format(remind.dateTime),
            style: _style.durationStyle)
      ];
}
