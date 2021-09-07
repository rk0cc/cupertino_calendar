part of '../reminds.dart';

/// An object of remind's basic information
abstract class DateRemind {
  /// Remind's name
  final String name;
  final DateTime _dt;

  /// Provides remind [name] and [dateTime]
  DateRemind(this.name, DateTime dateTime) : _dt = dateTime;

  /// Generate [json] object
  Map<String, dynamic> get json;

  /// Checking this remind is ongoing
  bool isOngoing(DateTime dateTime) =>
      dateTime.year == _dt.year &&
      dateTime.month == _dt.month &&
      dateTime.day == _dt.day;
}

/// Extended class from [DateRemind] with duration of this remind
abstract class DurationDateRemind extends DateRemind {
  final DateTime _untilDt;

  /// Create new remind with [name] and holding time [from] and [to]
  DurationDateRemind(String name, DateTime from, DateTime to)
      : _untilDt = to,
        assert(from.isBefore(to) &&
            to.isAfter(from) &&
            !from.isAtSameMomentAs(to)),
        super(name, from);

  @override
  bool isOngoing(DateTime dateTime) =>
      dateTime.isAfter(_dt) && dateTime.isBefore(_untilDt);
}
