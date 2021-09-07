part of '../reminds.dart';

/// An object for repersenting holiday
class Holiday extends SingleDateRemind {
  /// Create holiday
  Holiday({required String name, required DateTime date}) : super(name, date);

  /// Create holiday with [date] [String]
  Holiday.parse({required String name, required String date})
      : super(name, DateFormat("yyyy-MM-dd").parse(date));

  /// Get [Holiday]'s [DateTime]
  DateTime get dateTime => _dt;

  @override
  Map<String, dynamic> get json => {
        "holiday": {"name": name, "date": getDString(_dt)}
      };
}
