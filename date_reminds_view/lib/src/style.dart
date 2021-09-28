import 'package:flutter/cupertino.dart';

@immutable
class DateRemindWidgetStyle {
  final Color? eventsBorderColour;
  final Color holidayBorderColour;
  final Color? backgroundColour;
  final Radius borderRadius;
  final TextStyle titleStyle;
  final TextStyle descStyle;
  final TextStyle durationStyle;

  const DateRemindWidgetStyle(
      {this.eventsBorderColour,
      this.holidayBorderColour = CupertinoColors.systemRed,
      this.borderRadius = const Radius.circular(5),
      this.backgroundColour,
      this.titleStyle =
          const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      this.descStyle =
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
      this.durationStyle =
          const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)});
}
