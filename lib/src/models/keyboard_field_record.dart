import 'package:flutter/material.dart';

/// A Dart-3 record that couples a [FocusNode] with a [TextEditingController].
///
/// Declare one per form field, dispose in a single loop, and wire both to the
/// matching [TextField]:
///
/// ```dart
/// // 1. Declare
/// final _name  = kbField();
/// final _email = kbField();
///
/// // 2. Dispose
/// @override
/// void dispose() {
///   for (final f in [_name, _email]) {
///     f.focus.dispose();
///     f.ctrl.dispose();
///   }
///   super.dispose();
/// }
///
/// // 3. Wire to TextField
/// TextField(focusNode: _name.focus, controller: _name.ctrl)
/// ```
typedef KbField = ({FocusNode focus, TextEditingController ctrl});

/// Creates a new [KbField] with a fresh [FocusNode] and [TextEditingController].
KbField kbField({String? debugLabel}) => (
      focus: FocusNode(debugLabel: debugLabel),
      ctrl: TextEditingController(),
    );
