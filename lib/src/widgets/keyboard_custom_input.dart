import 'package:flutter/material.dart';

/// Signature for building a custom input display widget.
/// [value] is the current value; [hasFocus] reflects focus state.
typedef KeyboardCustomBuilder<T> = Widget Function(
  BuildContext context,
  T value,
  bool hasFocus,
);

/// A tappable field that shows a custom UI (via [KeyboardBarItem.footer])
/// instead of the system keyboard.
///
/// Pair it with a [KeyboardBarItem] whose `footer` is your custom keyboard panel.
/// The [notifier] is shared between this widget and the panel — update it from
/// the panel and the display reflects the change immediately.
///
/// ```dart
/// final _dateNotifier = ValueNotifier<DateTime>(DateTime.now());
/// final _dateItem = KeyboardBarItem(
///   footer: MyDatePickerPanel(notifier: _dateNotifier),
/// );
///
/// KeyboardCustomInput<DateTime>(
///   focusNode: _dateItem.focusNode,
///   notifier: _dateNotifier,
///   builder: (ctx, value, hasFocus) => Text('${value.toLocal()}'),
/// )
/// ```
class KeyboardCustomInput<T> extends StatefulWidget {
  final FocusNode focusNode;
  final ValueNotifier<T> notifier;
  final KeyboardCustomBuilder<T> builder;
  final double? height;
  final InputDecoration? decoration;

  const KeyboardCustomInput({
    super.key,
    required this.focusNode,
    required this.notifier,
    required this.builder,
    this.height,
    this.decoration,
  });

  @override
  State<KeyboardCustomInput<T>> createState() => _KeyboardCustomInputState<T>();
}

class _KeyboardCustomInputState<T> extends State<KeyboardCustomInput<T>>
    with AutomaticKeepAliveClientMixin {
  late bool _hasFocus;

  @override
  void initState() {
    super.initState();
    _hasFocus = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() => _hasFocus = widget.focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Focus(
      focusNode: widget.focusNode,
      child: GestureDetector(
        onTap: () {
          if (!widget.focusNode.hasFocus) widget.focusNode.requestFocus();
        },
        child: InputDecorator(
          decoration: (widget.decoration ?? const InputDecoration()).copyWith(
            border: widget.decoration?.border ?? const OutlineInputBorder(),
          ),
          isFocused: _hasFocus,
          child: SizedBox(
            height: widget.height,
            child: ValueListenableBuilder<T>(
              valueListenable: widget.notifier,
              builder: (ctx, value, _) => widget.builder(ctx, value, _hasFocus),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// Mixin for a custom keyboard panel widget.
/// Mix into your panel's State and call [updateValue] to push a new value.
mixin KeyboardCustomPanelMixin<T> {
  ValueNotifier<T> get notifier;
  void updateValue(T value) => notifier.value = value;
}
