part of 'styles.dart';

/// Apply style for [DayBox]
@immutable
class DayBoxStyle {
  /// Define [DayBox]'s shape
  final BoxShape shape;

  /// Define [DayBox] padding size
  final EdgeInsets padding;

  /// Define selected theme preference
  final StageThemePrefs selected;

  /// Define unselected theme preference
  final StageThemePrefs unselected;

  /// Assign style data of [DayBox]
  const DayBoxStyle(
      {this.shape = BoxShape.rectangle,
      this.padding = const EdgeInsets.all(6),
      required this.selected,
      required this.unselected});

  /// Load default style data from [context]
  ///
  /// Use this if [DayBox]'s style assign as null
  factory DayBoxStyle.getContextDefault(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var activeStyle = StageThemePrefs(
        themeData.primaryColor,
        themeData.textTheme
            .copyWith(
                textStyle: TextStyle(color: themeData.primaryContrastingColor))
            .textStyle);
    var inactiveStyle = StageThemePrefs(
        themeData.scaffoldBackgroundColor, themeData.textTheme.textStyle);
    return DayBoxStyle(selected: activeStyle, unselected: inactiveStyle);
  }
}
