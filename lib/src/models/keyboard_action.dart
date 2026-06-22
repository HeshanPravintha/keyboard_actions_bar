import 'package:flutter/material.dart';

class KeyboardAction {
  final String? label;
  final IconData? icon;
  final void Function(FocusNode currentNode)? onTap;
  final Widget Function(BuildContext, FocusNode)? builder;

  // Internal flag so KeyboardToolbarView can apply config.defaultDoneWidget.
  final bool isDone;

  const KeyboardAction._({
    this.label,
    this.icon,
    this.onTap,
    this.builder,
    this.isDone = false,
  });

  /// Unfocuses the current field — closes the keyboard.
  /// [onTap] fires before the field loses focus (e.g. to submit a form).
  factory KeyboardAction.done({
    String label = 'Done',
    VoidCallback? onTap,
  }) =>
      KeyboardAction._(
        label: label,
        isDone: true,
        onTap: (node) {
          onTap?.call();
          (FocusManager.instance.primaryFocus ?? node).unfocus();
        },
      );

  /// Moves focus to the next field in traversal order.
  factory KeyboardAction.next({IconData icon = Icons.keyboard_arrow_down}) =>
      KeyboardAction._(
        icon: icon,
        onTap: (node) {
          final focus = FocusManager.instance.primaryFocus ?? node;
          final ctx = focus.context;
          if (ctx == null || !ctx.mounted) return;
          FocusTraversalGroup.of(ctx).next(focus);
        },
      );

  /// Moves focus to the previous field in traversal order.
  factory KeyboardAction.prev({IconData icon = Icons.keyboard_arrow_up}) =>
      KeyboardAction._(
        icon: icon,
        onTap: (node) {
          final focus = FocusManager.instance.primaryFocus ?? node;
          final ctx = focus.context;
          if (ctx == null || !ctx.mounted) return;
          FocusTraversalGroup.of(ctx).previous(focus);
        },
      );

  /// Inserts [char] at the cursor position of the given [TextEditingController].
  /// Defaults to `'@'` — useful for email fields.
  factory KeyboardAction.insertAt(
    TextEditingController controller, {
    String char = '@',
    String? label,
  }) =>
      KeyboardAction._(
        label: label ?? 'Insert $char',
        onTap: (_) {
          final t = controller.text;
          final at = controller.selection.isValid
              ? controller.selection.baseOffset
              : t.length;
          controller.value = controller.value.copyWith(
            text: '${t.substring(0, at)}$char${t.substring(at)}',
            selection: TextSelection.collapsed(offset: at + 1),
          );
        },
      );

  /// Clears the given [TextEditingController].
  factory KeyboardAction.clear(
    TextEditingController controller, {
    IconData icon = Icons.backspace_outlined,
  }) =>
      KeyboardAction._(
        icon: icon,
        onTap: (_) => controller.clear(),
      );

  /// A fully custom action.
  factory KeyboardAction.custom({
    String? label,
    IconData? icon,
    required void Function() onTap,
    Widget Function(BuildContext, FocusNode)? builder,
  }) =>
      KeyboardAction._(
        label: label,
        icon: icon,
        onTap: (_) => onTap(),
        builder: builder,
      );
}
