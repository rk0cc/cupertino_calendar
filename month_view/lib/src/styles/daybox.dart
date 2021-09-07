part of 'styles.dart';

class DayBoxStyle {
  final BoxShape shape;
  final EdgeInsets padding;
  final StageThemePrefs selected;
  final StageThemePrefs unselected;

  const DayBoxStyle(
      {this.shape = BoxShape.rectangle,
      this.padding = const EdgeInsets.all(6),
      required this.selected,
      required this.unselected});

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
