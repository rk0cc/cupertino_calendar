import 'package:cupertino_calendar_date_reminds_view/module.dart'
    show SelectDateRemindHandler;

class SelectedDateRemindHandlerPreference {
  final SelectDateRemindHandler? onPress;
  final SelectDateRemindHandler? onLongPress;

  SelectedDateRemindHandlerPreference({this.onPress, this.onLongPress});
}
