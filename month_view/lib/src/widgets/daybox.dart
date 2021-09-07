part of 'widgets.dart';

typedef SelectedDayCondition = bool Function(DateTime dbd);

abstract class DayBoxContent extends StatelessWidget {
  Widget? _render(BuildContext context);

  Widget build(BuildContext context) => Center(child: _render(context));
}

class PlaceholderDayBox extends DayBoxContent {
  PlaceholderDayBox() : super();

  @override
  Widget? _render(BuildContext context) => null;
}

class DayBox extends DayBoxContent {
  final SelectedDayCondition condition;
  final DateTime day;

  DayBox({required this.condition, required this.day});

  @override
  Widget? _render(BuildContext context) => Container();
}
