import 'package:cupertino_calendar_date_reminds_view/module.dart'
    show SelectDateRemindHandler, DateRemindWidget;

/// Based class for trigger event when user interact
abstract class CupertinoCalendarSelectAction<H extends Function> {
  /// When user one tap
  final H? onPress;

  /// When user press a while
  final H? onLongPress;

  /// Create new preference of select action
  CupertinoCalendarSelectAction(this.onPress, this.onLongPress);
}

/// An handler when selected [DateRemindWidget]
class SelectedDateRemindHandlerPreference
    extends CupertinoCalendarSelectAction<SelectDateRemindHandler> {
  /// Create new preference
  SelectedDateRemindHandlerPreference(
      {SelectDateRemindHandler? onPress, SelectDateRemindHandler? onLongPress})
      : super(onPress, onLongPress);
}
