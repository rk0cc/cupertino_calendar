import 'package:flutter/cupertino.dart';
import '../widgets/widgets.dart';

part 'daybox.dart';
part 'grid.dart';
part 'topbar.dart';

/// A style class to define differents stage when toggled
class StageThemePrefs {
  /// Background [Color] when this stage
  final Color background;

  /// Style of this stage
  final TextStyle textStyle;

  /// Create stage data
  StageThemePrefs(this.background, this.textStyle);
}
