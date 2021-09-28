part of 'dateremind.dart';

class EventsDateRemindWidget extends DateRemindWidget<Events> {
  EventsDateRemindWidget(Events events,
      {SelectDateRemindHandler? onPressed,
      SelectDateRemindHandler? onLongPressed,
      DateRemindWidgetStyle? style,
      String? locale})
      : super(events, onPressed, onLongPressed, style, locale);

  static String _generateFormattedDateString(DateTime dt, String? locale) =>
      (locale == null)
          ? DateFormat("yyyy-MM-dd HH:mm").format(dt)
          : DateFormat.yMd(locale).format(dt) +
              " " +
              DateFormat.Hm(locale).format(dt);

  @override
  BoxDecoration boxDecoration(BuildContext context) => BoxDecoration(
        borderRadius: BorderRadius.all(_style.borderRadius),
        border: Border.all(
            color: _style.eventsBorderColour ??
                CupertinoTheme.of(context).primaryColor),
        color: _style.backgroundColour,
      );

  @override
  List<Widget> childContent(BuildContext context) => [
        Padding(
            padding: EdgeInsets.only(bottom: 2.5),
            child: Text(remind.name, style: _style.titleStyle)),
        Text(remind.description ?? "", style: _style.descStyle),
        Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
                _generateFormattedDateString(remind.from, locale) +
                    " - " +
                    _generateFormattedDateString(remind.to, locale),
                style: _style.durationStyle))
      ];
}
