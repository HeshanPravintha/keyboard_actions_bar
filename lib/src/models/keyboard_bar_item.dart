import 'package:flutter/material.dart';
import 'keyboard_action.dart';

class KeyboardBarItem {
  final FocusNode focusNode;
  final List<KeyboardAction>? actions;
  final Widget? footer;

  /// When false, this field is skipped — no toolbar is shown when it gains focus.
  final bool enabled;

  /// When false, the toolbar row is hidden for this field (footer still shows).
  final bool displayActionBar;

  /// Alignment of the action buttons row. Defaults to [MainAxisAlignment.end].
  final MainAxisAlignment toolbarAlignment;

  final bool _ownsNode;

  KeyboardBarItem({
    FocusNode? focusNode,
    this.actions,
    this.footer,
    this.enabled = true,
    this.displayActionBar = true,
    this.toolbarAlignment = MainAxisAlignment.end,
  })  : focusNode = focusNode ?? FocusNode(),
        _ownsNode = focusNode == null;

  void dispose() {
    if (_ownsNode) focusNode.dispose();
  }
}
