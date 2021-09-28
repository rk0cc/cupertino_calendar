import 'dateremind/dateremind.dart';
import 'package:flutter/cupertino.dart';

/// Apply custom style data of [DateRemindWidget]
@immutable
class DateRemindWidgetStyle {
  /// A [Color] for [BoxBorder] in [EventsDateRemindWidget]
  final Color? eventsBorderColour;

  /// A [Color] for [BoxBorder] in [HolidayDateRemindWidget]
  final Color? holidayBorderColour;

  /// Background [Color] for [DateRemindWidget]
  final Color? backgroundColour;

  /// [Radius] for [DateRemindWidget], default use `5` in [Radius.circular]
  final Radius borderRadius;

  /// [TextStyle] data of title
  final TextStyle titleStyle;

  /// [TextStyle] data of description
  final TextStyle descStyle;

  /// [TextStyle] data of duration
  final TextStyle durationStyle;

  const DateRemindWidgetStyle(
      {this.eventsBorderColour,
      this.holidayBorderColour,
      this.borderRadius = const Radius.circular(5),
      this.backgroundColour,
      this.titleStyle =
          const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      this.descStyle =
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
      this.durationStyle =
          const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)});
}
