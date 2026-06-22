import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'keyboard_field.dart';
import '../models/keyboard_action.dart';

/// A [TextField] with a built-in keyboard toolbar.
///
/// Drop-in replacement for [TextField] — just add [actions] and [footer].
/// No need to wrap with [KeyboardField].
///
/// ```dart
/// KeyboardTextField(
///   controller: _nameCtrl,
///   textInputAction: TextInputAction.next,
///   actions: [KeyboardAction.prev(), KeyboardAction.next(), KeyboardAction.done()],
///   decoration: InputDecoration(labelText: 'Full name'),
/// )
/// ```
class KeyboardTextField extends StatefulWidget {
  // ── Toolbar extras ───────────────────────────────────────────────
  final List<KeyboardAction>? actions;
  final Widget? footer;

  // ── TextField params ─────────────────────────────────────────────
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool expands;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final bool? enabled;
  final bool autocorrect;
  final bool enableSuggestions;
  final Color? cursorColor;
  final double? cursorHeight;
  final double cursorWidth;
  final bool? showCursor;
  final String obscuringCharacter;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final String? restorationId;
  final ScrollController? scrollController;
  final EdgeInsets scrollPadding;
  final Brightness? keyboardAppearance;

  const KeyboardTextField({
    super.key,
    this.actions,
    this.footer,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.expands = false,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.cursorColor,
    this.cursorHeight,
    this.cursorWidth = 2.0,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.inputFormatters,
    this.restorationId,
    this.scrollController,
    this.scrollPadding = const EdgeInsets.all(20),
    this.keyboardAppearance,
  });

  @override
  State<KeyboardTextField> createState() => _KeyboardTextFieldState();
}

class _KeyboardTextFieldState extends State<KeyboardTextField> {
  FocusNode? _ownedNode;
  late FocusNode _node;

  @override
  void initState() {
    super.initState();
    _node = widget.focusNode ?? (_ownedNode = FocusNode());
  }

  @override
  void didUpdateWidget(KeyboardTextField old) {
    super.didUpdateWidget(old);
    if (widget.focusNode != old.focusNode) {
      _ownedNode?.dispose();
      _ownedNode = null;
      _node = widget.focusNode ?? (_ownedNode = FocusNode());
    }
  }

  @override
  void dispose() {
    _ownedNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardField(
      focusNode: _node,
      actions: widget.actions,
      footer: widget.footer,
      child: TextField(
        focusNode: _node,
        controller: widget.controller,
        decoration: widget.decoration,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        textDirection: widget.textDirection,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        expands: widget.expands,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        cursorColor: widget.cursorColor,
        cursorHeight: widget.cursorHeight,
        cursorWidth: widget.cursorWidth,
        showCursor: widget.showCursor,
        obscuringCharacter: widget.obscuringCharacter,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        onEditingComplete: widget.onEditingComplete,
        inputFormatters: widget.inputFormatters,
        restorationId: widget.restorationId,
        scrollController: widget.scrollController,
        scrollPadding: widget.scrollPadding,
        keyboardAppearance: widget.keyboardAppearance,
      ),
    );
  }
}
