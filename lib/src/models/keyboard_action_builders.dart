import 'package:flutter/material.dart';
import 'keyboard_field_record.dart';
import 'keyboard_action.dart';

abstract final class KeyboardActionBuilders {
  static KeyboardAction insertAt(
    KbField field, {
    String char = '@',
    String? label,
  }) =>
      KeyboardAction.custom(
        label: label ?? 'Insert $char',
        onTap: () {
          final t = field.ctrl.text;
          final at = field.ctrl.selection.isValid
              ? field.ctrl.selection.baseOffset
              : t.length;
          field.ctrl.value = field.ctrl.value.copyWith(
            text: '${t.substring(0, at)}$char${t.substring(at)}',
            selection: TextSelection.collapsed(offset: at + 1),
          );
        },
      );

  static KeyboardAction clear(
    KbField field, {
    IconData icon = Icons.backspace_outlined,
  }) =>
      KeyboardAction.clear(field.ctrl, icon: icon);
}
