part of 'widgets.dart';

class CalendarTopBar extends StatelessWidget {
  final YearMonth yearMonth;
  final void Function() onPrevious;
  final void Function() onNext;

  CalendarTopBar(
      {required this.yearMonth,
      required this.onPrevious,
      required this.onNext});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
