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
  final SelectedDayCondition condition;
  final DateTime day;
  final DayBoxStyle? style;

  DayBox({required this.condition, required this.day, this.style});

  @override
  Widget? _render(BuildContext context) {
    DayBoxStyle applyStyle = style ?? DayBoxStyle.getContextDefault(context);
    var themeProfile =
        condition(day) ? applyStyle.selected : applyStyle.unselected;
    return Container(
        alignment: Alignment.center,
        padding: applyStyle.padding,
        decoration: BoxDecoration(
            shape: applyStyle.shape, color: themeProfile.background),
        child: Text(day.day.toString(),
            style: themeProfile.textStyle, textAlign: TextAlign.center),
        clipBehavior: Clip.antiAlias);
  }
}
