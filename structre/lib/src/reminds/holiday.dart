part of '../reminds.dart';

class Holiday extends DateRemind {
  Holiday(String name, DateTime dateTime) : super(name, dateTime);

  DateTime get dateTime => _dt;

  @override
  Map<String, dynamic> get json => {
        "holiday": {"name": name, "date": getDTString(_dt)}
      };
}
