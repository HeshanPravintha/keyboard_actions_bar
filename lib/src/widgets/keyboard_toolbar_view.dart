import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/keyboard_action.dart';
import '../models/keyboard_config.dart';

/// The toolbar UI rendered above the keyboard.
/// Stateless — receives everything it needs from [KeyboardActionsBar].
class KeyboardToolbarView extends StatelessWidget {
  final List<KeyboardAction> actions;
  final FocusNode currentFocus;
  final KeyboardConfig config;
  final Widget? footer;
  final bool displayActionBar;
  final MainAxisAlignment toolbarAlignment;

  const KeyboardToolbarView({
    super.key,
    required this.actions,
    required this.currentFocus,
    required this.config,
    this.footer,
    this.displayActionBar = true,
    this.toolbarAlignment = MainAxisAlignment.end,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final bg = config.backgroundColor ??
        (theme.useMaterial3
            ? cs.surfaceContainerHigh
            : (theme.brightness == Brightness.dark
                ? Colors.grey[850]!
                : Colors.grey[100]!));

    final separatorColor = config.separatorColor ?? cs.outlineVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (config.elevation > 0)
          Container(
            height: config.elevation.clamp(0, 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(
                    alpha: 0.06 * config.elevation.clamp(0, 4),
                  ),
                ],
              ),
            ),
          ),
        if (config.showSeparator)
          Divider(height: 0.5, thickness: 0.5, color: separatorColor),
        if (displayActionBar)
          Container(
            height: config.height,
            color: bg,
            child: Row(
              mainAxisAlignment: toolbarAlignment,
              children: [
                if (toolbarAlignment != MainAxisAlignment.end) const Spacer(),
                ...actions.map(
                  (action) => _ActionButton(
                    action: action,
                    focusNode: currentFocus,
                    theme: theme,
                    config: config,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        if (footer != null) footer!,
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final KeyboardAction action;
  final FocusNode focusNode;
  final ThemeData theme;
  final KeyboardConfig config;

  const _ActionButton({
    required this.action,
    required this.focusNode,
    required this.theme,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    if (action.builder != null) {
      return action.builder!(context, focusNode);
    }

    final cs = theme.colorScheme;

    // Done button — apply config overrides if provided.
    if (action.isDone && config.defaultDoneWidget != null) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          action.onTap?.call(focusNode);
        },
        child: config.defaultDoneWidget,
      );
    }

    Widget content;
    if (action.icon != null) {
      content = Icon(action.icon, size: 22, color: cs.onSurface);
    } else {
      final label = (action.isDone && config.defaultDoneButtonText != 'Done')
          ? config.defaultDoneButtonText
          : (action.label ?? '');
      content = Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          action.onTap?.call(focusNode);
        },
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: content,
        ),
      ),
    );
  }
}
