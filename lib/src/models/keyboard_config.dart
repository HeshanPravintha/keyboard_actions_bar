import 'package:flutter/material.dart';
import 'keyboard_action.dart';
import 'tap_outside_behavior.dart';

class KeyboardConfig {
  final Color? backgroundColor;
  final double height;
  final bool showOnAndroid;
  final bool showOnIOS;
  final bool showOnWeb;
  final List<KeyboardAction>? defaultActions;
  final bool showSeparator;
  final Color? separatorColor;
  final double elevation;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool autoScrollToFocused;

  /// Custom widget rendered in place of the "Done" button.
  final Widget? defaultDoneWidget;

  /// Text label for the default Done button. Ignored when [defaultDoneWidget] is set.
  final String defaultDoneButtonText;

  /// Controls what happens when the user taps outside the keyboard area.
  final TapOutsideBehavior tapOutsideBehavior;

  const KeyboardConfig({
    this.backgroundColor,
    this.height = 44,
    this.showOnAndroid = false,
    this.showOnIOS = true,
    this.showOnWeb = false,
    this.defaultActions,
    this.showSeparator = true,
    this.separatorColor,
    this.elevation = 0,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeOut,
    this.autoScrollToFocused = false,
    this.defaultDoneWidget,
    this.defaultDoneButtonText = 'Done',
    this.tapOutsideBehavior = TapOutsideBehavior.none,
  });

  static const KeyboardConfig allPlatforms = KeyboardConfig(
    showOnAndroid: true,
    showOnIOS: true,
    showOnWeb: true,
  );
}
