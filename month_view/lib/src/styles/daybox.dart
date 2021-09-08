part of 'styles.dart';

/// Apply style for [DayBox]
@immutable
class DayBoxStyle {
  /// Define [DayBox]'s shape
  final BoxShape shape;

  /// Define [DayBox] padding size
  final EdgeInsets padding;

  /// Define selected background colour
  final Color? selectedBackground;

  /// Define unselected background colour
  final Color? unselectedBackground;

  /// Define selected text colour
  final TextStyle? selectedTextStyle;

  /// Define unselected text colour
  final TextStyle? unselectedTextStyle;

  /// Define unselected text colour when [DayBox] containing Saturday [DateTime]
  ///
  /// It will use [unselectedTextStyle] if omitted
  final TextStyle? unselectedSaturdayTextStyle;

  /// Define unselected text colour when [DayBox] containing Sunday [DateTime]
  /// or this day is [Holiday]
  final TextStyle? unselectedHolidayTextStyle;

  /// Assign style data of [DayBox]
  const DayBoxStyle(
      {this.shape = BoxShape.rectangle,
      this.padding = const EdgeInsets.all(6),
      this.selectedBackground,
      this.unselectedBackground,
      this.selectedTextStyle,
      this.unselectedTextStyle,
      this.unselectedSaturdayTextStyle,
      this.unselectedHolidayTextStyle});
}
