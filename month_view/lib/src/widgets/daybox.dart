part of 'widgets.dart';

/// A handler for day in [DayBox]
///
/// [dbd] is [DateTime] of [DayBox]
typedef DayCondition = bool Function(DateTime dbd);

/// A generic class for building context of the grid
abstract class DayBoxContent extends StatelessWidget {
  Widget? _render(BuildContext context);

  @override
  Widget build(BuildContext context) => Center(child: _render(context));
}

/// A class which extended from [DayBoxContent] but absolutely nothing inside
class PlaceholderDayBox extends DayBoxContent {
  /// Create placeholder to do absolutely nothing here
  PlaceholderDayBox() : super();

  @override
  Widget? _render(BuildContext context) => null;
}

/// Actual display [day]'s [Widget]
class DayBox extends DayBoxContent {
  /// A method for checking this [day] is equal with picked date
  final DayCondition pickedCondition;

  /// Check this day is a holiday
  final DayCondition isHoliday;

  /// Check has [Events] on this day
  final DayCondition hasEvent;

  /// Day of this [DayBox]
  final DateTime day;

  /// Style of this [DayBox]
  final DayBoxStyle? style;

  /// Get a [Widget] of this [day]
  DayBox(
      {required this.pickedCondition,
      required this.isHoliday,
      required this.hasEvent,
      required this.day,
      this.style});

  @override
  Widget? _render(BuildContext context) {
    // Load applied style, use default theme if not applied
    DayBoxStyle applyStyle = style ?? DayBoxStyle();

    // Get theme preference from theme data
    var themeData = CupertinoTheme.of(context);

    // Background colour
    var bg = pickedCondition(day)
        // Picked
        ? applyStyle.selectedBackground ?? themeData.primaryColor
        // Unpicked
        : applyStyle.unselectedBackground;

    // Text style
    var ts = pickedCondition(day)
        // Picked
        ? applyStyle.selectedTextStyle ??
            themeData.textTheme
                .copyWith(
                    textStyle:
                        TextStyle(color: themeData.primaryContrastingColor))
                .textStyle
        // Unpicked
        : (() {
            var hdayTheme = applyStyle.unselectedHolidayTextStyle ??
                themeData.textTheme
                    .copyWith(
                        textStyle: TextStyle(color: CupertinoColors.systemRed))
                    .textStyle;

            // Override theme if this day is a holiday
            if (isHoliday(day)) {
              return hdayTheme;
            }

            // Use oridinary text style if not holiday
            switch (day.weekday) {
              case 7:
                // Sunday also is a holiday
                return hdayTheme;
              case 6:
                // Saturday can be applied by another colour
                return applyStyle.unselectedSaturdayTextStyle ??
                    applyStyle.unselectedTextStyle;
              default:
                return applyStyle.unselectedTextStyle;
            }
          })();
    return Container(
        alignment: Alignment.center,
        padding: applyStyle.padding,
        decoration: BoxDecoration(shape: applyStyle.shape, color: bg),
        clipBehavior: Clip.antiAlias,
        child:
            Text(day.day.toString(), style: ts, textAlign: TextAlign.center));
  }
}
