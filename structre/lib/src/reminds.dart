import 'dart:collection';
import 'dart:html';

import 'package:intl/intl.dart';
import 'date.dart' show getDTString;
part 'reminds/abstract.dart';
part 'reminds/events.dart';
part 'reminds/holiday.dart';

typedef DateRemindObjectResolver = void Function(List<DateRemind> dr);

class DateRemindList extends ListBase<DateRemind> {
  final List<DateRemind> _drl;

  DateRemindList([List<DateRemind> drl = const <DateRemind>[]]) : _drl = drl;

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
}
