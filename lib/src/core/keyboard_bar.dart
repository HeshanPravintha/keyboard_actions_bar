import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/keyboard_action.dart';
import '../models/keyboard_bar_item.dart';
import '../models/keyboard_config.dart';
import '../models/tap_outside_behavior.dart';
import '../utils/platform_util.dart';
import '../widgets/keyboard_toolbar_view.dart';

class KeyboardActionsBar extends StatefulWidget {
  final Widget child;
  final KeyboardConfig config;
  final List<KeyboardBarItem>? items;

  const KeyboardActionsBar({
    super.key,
    required this.child,
    this.config = const KeyboardConfig(),
    this.items,
  });

  @override
  State<KeyboardActionsBar> createState() => _KeyboardActionsBarState();
}

class _KeyboardActionsBarState extends State<KeyboardActionsBar>
    with WidgetsBindingObserver {
  FocusNode? _focusedNode;
  List<KeyboardAction>? _fieldActions;
  Widget? _fieldFooter;
  bool _displayActionBar = true;
  MainAxisAlignment _toolbarAlignment = MainAxisAlignment.end;

  double _observedKeyboardH = 0;
  double _maxBodyHeight = 0;
  bool? _lastIsPortrait;

  final Map<FocusNode, VoidCallback> _itemListeners = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _attachItems(widget.items);
  }

  @override
  void didUpdateWidget(KeyboardActionsBar old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) {
      _detachItems(old.items);
      _attachItems(widget.items);
    }
  }

  @override
  void dispose() {
    _detachItems(widget.items);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _attachItems(List<KeyboardBarItem>? items) {
    for (final item in items ?? []) {
      void listener() => _onItemFocusChange(item);
      _itemListeners[item.focusNode] = listener;
      item.focusNode.addListener(listener);
    }
  }

  void _detachItems(List<KeyboardBarItem>? items) {
    for (final item in items ?? []) {
      final listener = _itemListeners.remove(item.focusNode);
      if (listener != null) item.focusNode.removeListener(listener);
    }
  }

  void _onItemFocusChange(KeyboardBarItem item) {
    if (!mounted) return;
    if (item.focusNode.hasFocus) {
      if (!item.enabled) return; // skip disabled fields
      onFocusGained(
        item.focusNode,
        item.actions,
        item.footer,
        displayActionBar: item.displayActionBar,
        toolbarAlignment: item.toolbarAlignment,
      );
    } else {
      onFocusLost(item.focusNode);
    }
  }

  @override
  void didChangeMetrics() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return;
    final view = views.first;
    final h = view.viewInsets.bottom / view.devicePixelRatio;
    if (h != _observedKeyboardH) {
      setState(() => _observedKeyboardH = h);
    }
  }

  void onFocusGained(
    FocusNode node,
    List<KeyboardAction>? actions,
    Widget? footer, {
    bool displayActionBar = true,
    MainAxisAlignment toolbarAlignment = MainAxisAlignment.end,
  }) {
    setState(() {
      _focusedNode = node;
      _fieldActions = actions;
      _fieldFooter = footer;
      _displayActionBar = displayActionBar;
      _toolbarAlignment = toolbarAlignment;
    });
  }

  void onFocusLost(FocusNode node) {
    if (_focusedNode != node) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _focusedNode != node) return;
      if (!node.hasFocus) {
        setState(() {
          _focusedNode = null;
          _fieldActions = null;
          _fieldFooter = null;
          _displayActionBar = true;
          _toolbarAlignment = MainAxisAlignment.end;
        });
      }
    });
  }

  bool _shouldShow(double keyboardHeight) {
    if (keyboardHeight < 50 || _focusedNode == null) return false;
    if (PlatformUtil.isWeb) return widget.config.showOnWeb;
    if (PlatformUtil.isAndroid) return widget.config.showOnAndroid;
    if (PlatformUtil.isIOS) return widget.config.showOnIOS;
    return false;
  }

  List<KeyboardAction> get _effectiveActions =>
      _fieldActions?.isNotEmpty == true
          ? _fieldActions!
          : widget.config.defaultActions ??
              [
                KeyboardAction.prev(),
                KeyboardAction.next(),
                KeyboardAction.done(),
              ];

  @override
  Widget build(BuildContext context) {
    final insetsH = MediaQuery.viewInsetsOf(context).bottom;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final currentH = constraints.maxHeight;
        final isPortrait = constraints.maxWidth < constraints.maxHeight;

        if (_lastIsPortrait != null && _lastIsPortrait != isPortrait) {
          _maxBodyHeight = 0;
        }
        _lastIsPortrait = isPortrait;

        if (currentH > 150 && currentH > _maxBodyHeight) {
          _maxBodyHeight = currentH;
        }

        final shrinkH = _maxBodyHeight > 150
            ? math.max(0.0, _maxBodyHeight - currentH)
            : 0.0;

        final keyboardH =
            math.max(math.max(insetsH, shrinkH), _observedKeyboardH);
        final shouldShow = _shouldShow(keyboardH);

        Widget content = widget.child;

        // Tap-outside overlay — covers content area when keyboard is visible.
        if (shouldShow &&
            widget.config.tapOutsideBehavior != TapOutsideBehavior.none) {
          content = Stack(
            children: [
              widget.child,
              Positioned.fill(
                child: Listener(
                  onPointerDown: (_) => _focusedNode?.unfocus(),
                  behavior: widget.config.tapOutsideBehavior ==
                          TapOutsideBehavior.translucentDismiss
                      ? HitTestBehavior.translucent
                      : HitTestBehavior.opaque,
                ),
              ),
            ],
          );
        }

        return _KeyboardActionsBarScope(
          state: this,
          child: Column(
            children: [
              Expanded(child: content),
              AnimatedSize(
                duration: widget.config.animationDuration,
                curve: widget.config.animationCurve,
                child: shouldShow && _focusedNode != null
                    ? KeyboardToolbarView(
                        actions: _effectiveActions,
                        currentFocus: _focusedNode!,
                        config: widget.config,
                        footer: _fieldFooter,
                        displayActionBar: _displayActionBar,
                        toolbarAlignment: _toolbarAlignment,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _KeyboardActionsBarScope extends InheritedWidget {
  final _KeyboardActionsBarState state;

  const _KeyboardActionsBarScope({
    required this.state,
    required super.child,
  });

  static _KeyboardActionsBarState? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_KeyboardActionsBarScope>()
      ?.state;

  @override
  bool updateShouldNotify(_KeyboardActionsBarScope old) => state != old.state;
}

// ─────────────────────────────────────────────────────────────────────────────

/// Listens to a [FocusNode] and notifies the nearest [KeyboardActionsBar].
/// Used internally by [KeyboardField].
class FocusWatcher extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;
  final List<KeyboardAction>? actions;
  final Widget? footer;
  final bool displayActionBar;
  final MainAxisAlignment toolbarAlignment;
  final bool ownsNode;

  const FocusWatcher({
    super.key,
    required this.child,
    required this.focusNode,
    this.actions,
    this.footer,
    this.displayActionBar = true,
    this.toolbarAlignment = MainAxisAlignment.end,
    this.ownsNode = false,
  });

  @override
  State<FocusWatcher> createState() => _FocusWatcherState();
}

class _FocusWatcherState extends State<FocusWatcher> {
  late FocusNode _node;

  @override
  void initState() {
    super.initState();
    _node = widget.focusNode;
    _node.addListener(_onNodeChange);
    FocusManager.instance.addListener(_onGlobalFocusChange);
  }

  @override
  void didUpdateWidget(FocusWatcher old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      old.focusNode.removeListener(_onNodeChange);
      if (old.ownsNode) old.focusNode.dispose();
      _node = widget.focusNode;
      _node.addListener(_onNodeChange);
    }
  }

  @override
  void dispose() {
    _node.removeListener(_onNodeChange);
    FocusManager.instance.removeListener(_onGlobalFocusChange);
    if (widget.ownsNode) _node.dispose();
    super.dispose();
  }

  void _onNodeChange() {
    if (!mounted) return;
    _report();
  }

  void _onGlobalFocusChange() {
    if (!mounted) return;
    _report();
  }

  void _report() {
    final bar = _KeyboardActionsBarScope.of(context);
    if (bar == null) return;
    if (_node.hasFocus) {
      bar.onFocusGained(
        _node,
        widget.actions,
        widget.footer,
        displayActionBar: widget.displayActionBar,
        toolbarAlignment: widget.toolbarAlignment,
      );
    } else {
      bar.onFocusLost(_node);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
