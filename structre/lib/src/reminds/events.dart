part of '../reminds.dart';

/// A simple event object for Cupertno Calendar
class Events extends DurationDateRemind {
  /// Optional string for describe this [Events]
  final String? description;

  /// Create new [Events]
  Events(
      {required String name,
      required DateTime from,
      required DateTime to,
      this.description})
      : super(name, from, to);

  /// Get when this [Events] start
  DateTime get from => _dt;

  /// Get when this [Events] end
  DateTime get to => _untilDt;

  @override
  Map<String, dynamic> get json => {
        "events": {
          "name": name,
          "description": description,
          "duration": {"from": getDTString(_dt), "to": getDTString(_untilDt)}
        }
      };
}

/// An [Events] which hold a whole day
class AllDayEvents extends Events {
  /// Create all day events
  AllDayEvents(
      {required String name,
      required DateTime from,
      required DateTime to,
      String? description})
      : super(
            name: name,
            from: DateTime(from.year, from.month, from.day, 0, 0, 0),
            to: DateTime(to.year, to.month, to.day, 23, 59, 59),
            description: description);
}
