import 'package:cupertino_calendar_structre/cupertino_calendar_structre.dart';

void main() {
  // YearMonth demo
  YearMonth ym1 = YearMonth(2021, 2);

  // There are 28 days in Feb 2021
  print("Date in ${ym1.formatString()}: ${ym1.allDaysInMonth.length}");

  // It is greater than January
  print(ym1 > YearMonth(2021, 1));

  FirstDayOfWeek fdow = FirstDayOfWeek.sun;

  // Get placeholder in this month
  print(
      "In ${ym1.formatString()}, it swifted ${fdow.calculatePlaceholderFromStart(ym1)} from begin and ${fdow.calculatePlaceholderFromEnd(ym1)} from end if Sunday is the first day of the week");

  // Date remind section
  Events sampleEvent = Events(
      name: "Sample events",
      from: DateTime(2021, 8, 1, 13, 0, 0),
      to: DateTime(2021, 8, 1, 15, 0, 0));

  print(
      "Event '${sampleEvent.name}' is ongoing: ${sampleEvent.isOngoing(DateTime.now())}");
}
