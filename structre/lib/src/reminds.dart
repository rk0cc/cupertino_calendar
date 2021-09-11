import 'dart:collection';
import 'package:intl/intl.dart';
import 'date.dart' show getDTString, getDString;
part 'reminds/abstract.dart';
part 'reminds/events.dart';
part 'reminds/holiday.dart';

/// Resolving date remind object which crawl from other sources
///
/// [dr] is the [List] of [Events] and [Holiday] which stored in [DateRemindList] internally
typedef DateRemindObjectResolver = void Function(List<DateRemind> dr);

/// A list for containing [Events] and [Holiday] object
class DateRemindList extends ListBase<DateRemind> {
  final List<DateRemind> _drl;

  /// Create new list data
  ///
  /// You can apply [drl] if you decide to import existed [DateRemind]
  DateRemindList([List<DateRemind> drl = const <DateRemind>[]]) : _drl = drl;

  /// Create list with [DateRemindObjectResolver]
  DateRemindList._resolver(DateRemindObjectResolver resolver) : _drl = [] {
    resolver(_drl);
  }

  @override
  int get length => _drl.length;

  @override
  DateRemind operator [](int index) => _drl[index];

  @override
  void operator []=(int index, DateRemind value) => _drl[index] = value;

  /// [DateRemindList] can not assign new length
  ///
  /// It will throws [UnsupportedError] if did it
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

class DateRemindListConversion {
  /// Load a [List] of [source] from other classes
  ///
  /// Define [eventsCondition] and [holidayCondition] to check [S] is validate
  /// structre to create [Events] or [Holiday].
  /// Once it mathced, it will generated to [Events] or [Holiday] in
  /// [exportEvents] or [exportHoliday]
  static DateRemindList convertListFromSource<S>(List<S> source,
          {required bool Function(S) eventsCondition,
          required bool Function(S) holidayCondition,
          required Events Function(S) exportEvents,
          required Holiday Function(S) exportHoliday}) =>
      DateRemindList._resolver((dr) {
        source.forEach((srcdr) {
          if (eventsCondition(srcdr))
            dr.add(exportEvents(srcdr));
          else if (holidayCondition(srcdr)) dr.add(exportHoliday(srcdr));
        });
      });

  /// Getting [Events] and [Holiday] on different classes
  ///
  /// Unlike [convertListFromSource], it reduced the workflow of checking [Type]
  /// and it will merge to [DateRemindList] after conversion completed.
  static DateRemindList convertListFromDividedSource<E, H>(
          List<E> eventsSource, List<H> holidaySource,
          {required Events Function(E) exportEvents,
          required Holiday Function(H) exportHoliday}) =>
      DateRemindList._resolver((dr) => dr
        ..addAll(eventsSource.map((e) => exportEvents(e)))
        ..addAll(holidaySource.map((h) => exportHoliday(h))));
}
