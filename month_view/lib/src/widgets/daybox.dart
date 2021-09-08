part of 'widgets.dart';

/// A handler for checking picked day
///
/// [dbd] is [DateTime] of [DayBox]
typedef SelectedDayCondition = bool Function(DateTime dbd);

/// A generic class for building context of the grid
abstract class DayBoxContent extends StatelessWidget {
  Widget? _render(BuildContext context);

  Widget build(BuildContext context) => Center(child: _render(context));
}

/// A class which extended from [DayBoxContent] but absolutely nothing inside
class PlaceholderDayBox extends DayBoxContent {
  PlaceholderDayBox() : super();

  @override
  Widget? _render(BuildContext context) => null;
}

/// Actual display [day]'s [Widget]
class DayBox extends DayBoxContent {
  /// A method for checking this [day] is equal with picked date
  final SelectedDayCondition condition;

  /// Day of this [DayBox]
  final DateTime day;

  /// Style of this [DAYbOX]
  final DayBoxStyle? style;

  DayBox({required this.condition, required this.day, this.style});

  @override
  Widget? _render(BuildContext context) {
    DayBoxStyle applyStyle = style ?? DayBoxStyle();
    var themeData = CupertinoTheme.of(context);
    var bg = condition(day)
        ? applyStyle.selectedBackground ?? themeData.primaryColor
        : applyStyle.unselectedBackground;
    var ts = condition(day)
        ? applyStyle.selectedTextStyle ??
            themeData.textTheme
                .copyWith(
                    textStyle:
                        TextStyle(color: themeData.primaryContrastingColor))
                .textStyle
        : applyStyle.unselectedTextStyle;
    return Container(
        alignment: Alignment.center,
        padding: applyStyle.padding,
        decoration: BoxDecoration(shape: applyStyle.shape, color: bg),
        clipBehavior: Clip.antiAlias,
        child:
            Text(day.day.toString(), style: ts, textAlign: TextAlign.center));
  }
}
