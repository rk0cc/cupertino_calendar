import 'dart:collection';
import 'package:intl/intl.dart';
import 'date.dart' show getDTString, getDString;
part 'reminds/abstract.dart';
part 'reminds/events.dart';
part 'reminds/holiday.dart';

/// Resolving date remind object which crawl from other sources
///
/// [dr] is the [List] which stored in [DateRemindList] internally
typedef DateRemindObjectResolver = void Function(List<DateRemind> dr);

/// A list for containing [DateRemind] object
class DateRemindList extends ListBase<DateRemind> {
  final List<DateRemind> _drl;

  /// Create new list data
  ///
  /// You can apply [drl] if you decide to import existed [DateRemind]
  DateRemindList([List<DateRemind> drl = const <DateRemind>[]]) : _drl = drl;

  /// Create list with [DateRemindObjectResolver]
  factory DateRemindList.resolver(DateRemindObjectResolver resolver) {
    List<DateRemind> dr = [];
    resolver(dr);
    return DateRemindList(dr);
  }

  @override
  int get length => _drl.length;

  @override
  DateRemind operator [](int index) => _drl[index];

  @override
  void operator []=(int index, DateRemind value) => _drl[index] = value;

  @override
  set length(int newLength) =>
      throw UnsupportedError("You can't assign new length in this list");

  /// Get all [Events] in this list
  List<Events> get events => _drl
      .where((dr) => dr is Events)
      .map((e) => e as Events)
      .toList(growable: false);

  /// Get all [Holiday] in this list
  List<Holiday> get holiday => _drl
      .where((dr) => dr is Holiday)
      .map((e) => e as Holiday)
      .toList(growable: false);
}
