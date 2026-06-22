import 'package:flutter/material.dart';
import 'keyboard_action.dart';

/// Passes per-field keyboard toolbar config down the widget tree.
/// Set by [KeyboardField], read by [KeyboardActionsBar].
class KeyboardFieldData extends InheritedWidget {
  final List<KeyboardAction>? actions;
  final Widget? footerBuilder;
  final FocusNode? focusNode;

  const KeyboardFieldData({
    super.key,
    required super.child,
    this.actions,
    this.footerBuilder,
    this.focusNode,
  });

  static KeyboardFieldData? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<KeyboardFieldData>();

  @override
  bool updateShouldNotify(KeyboardFieldData old) =>
      actions != old.actions ||
      footerBuilder != old.footerBuilder ||
      focusNode != old.focusNode;
}
