/// Provide basic structre to apply in Cupertino Calendar
library cupertino_calendar_structre;

export 'src/date.dart' hide getDTString, getDString;
export 'src/week.dart';
export 'src/reminds.dart'
    hide
        DateRemind,
        SingleDateRemind,
        DurationDateRemind,
        DateRemindGenerator,
        DateRemindListConversion;
