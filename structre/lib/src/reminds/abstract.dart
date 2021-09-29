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
  bool isOngoing(DateTime dateTime);
}

/// A [DateRemind] for happen in entire day without range
abstract class SingleDateRemind extends DateRemind {
  /// Create new [SingleDateRemind]
  SingleDateRemind(String name, DateTime dateTime) : super(name, dateTime);

  @override
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
  
  /// Check [dateTime]'s datetime is happening
  bool isHappening(DateTime dateTime) =>
      dateTime.isAfter(_dt) && dateTime.isBefore(_untilDt);

  /// Like [isOngoing], but check [dateTime]'s date only
  @override
  bool isOngoing(DateTime dateTime) =>
      (dateTime.year >= _dt.year &&
          dateTime.month >= _dt.month &&
          dateTime.day >= _dt.day) &&
      (dateTime.year <= _untilDt.year &&
          dateTime.month <= _untilDt.month &&
          dateTime.day <= _untilDt.day);

  /// Like [isOngoing], but check [dateTime]'s date only
  @Deprecated("Please uses isOngoing instead")
  bool isOngoingDate(DateTime dateTime) =>
      isOngoing(dateTime);
}

/// Allowing convert to [D] with existed class
///
/// [D] can be [Events], [Holiday] and inherited classes
mixin DateRemindGenerator<D extends DateRemind> {
  /// Export the [remindObject] in implemented class
  D get remindObject;
}
