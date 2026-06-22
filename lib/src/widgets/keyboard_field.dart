import 'package:flutter/material.dart';
import '../core/keyboard_bar.dart';
import '../models/keyboard_action.dart';

class KeyboardField extends StatefulWidget {
  final Widget child;
  final List<KeyboardAction>? actions;
  final Widget? footer;
  final FocusNode? focusNode;

  /// When false, the toolbar row is hidden for this field (footer still shows).
  final bool displayActionBar;

  /// Alignment of the action buttons row. Defaults to [MainAxisAlignment.end].
  final MainAxisAlignment toolbarAlignment;

  const KeyboardField({
    super.key,
    required this.child,
    this.actions,
    this.footer,
    this.focusNode,
    this.displayActionBar = true,
    this.toolbarAlignment = MainAxisAlignment.end,
  });

  @override
  State<KeyboardField> createState() => _KeyboardFieldState();
}

class _KeyboardFieldState extends State<KeyboardField> {
  FocusNode? _ownedNode;
  late FocusNode _node;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _node = widget.focusNode!;
    } else {
      _ownedNode = FocusNode();
      _node = _ownedNode!;
    }
  }

  @override
  void dispose() {
    _ownedNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inner = widget.focusNode != null
        ? widget.child
        : Focus(
            focusNode: _node,
            canRequestFocus: false,
            skipTraversal: true,
            child: widget.child,
          );

    return FocusWatcher(
      focusNode: _node,
      actions: widget.actions,
      footer: widget.footer,
      displayActionBar: widget.displayActionBar,
      toolbarAlignment: widget.toolbarAlignment,
      ownsNode: false,
      child: inner,
    );
  }
}
