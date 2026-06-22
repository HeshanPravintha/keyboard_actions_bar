/// keyboard_actions_bar — keyboard toolbar for Flutter forms.
///
/// Done / Next / Prev / Clear / Custom actions above the soft keyboard.
/// Zero FocusNode boilerplate. Material 3 themed. Dark mode aware.
///
/// ## Setup
/// ```dart
/// KeyboardActionsBar(
///   child: Column(children: [TextField(), TextField()]),
/// )
/// ```
library;

export 'src/core/keyboard_bar.dart' show KeyboardActionsBar, FocusWatcher;
export 'src/widgets/keyboard_field.dart';
export 'src/widgets/keyboard_text_field.dart';
export 'src/widgets/keyboard_toolbar_view.dart';
export 'src/models/keyboard_action.dart';
export 'src/models/keyboard_bar_item.dart';
export 'src/models/keyboard_config.dart';
export 'src/models/keyboard_field_record.dart';
export 'src/models/keyboard_action_builders.dart';
export 'src/models/tap_outside_behavior.dart';
export 'src/widgets/keyboard_custom_input.dart';
