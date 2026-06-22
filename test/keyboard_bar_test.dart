import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_actions_bar/keyboard_actions_bar.dart';

void main() {

  // ── KeyboardAction ──────────────────────────────────────────────────────────────
  group('KeyboardAction', () {
    testWidgets('done action unfocuses the current node', (tester) async {
      final node = FocusNode();
      final action = KeyboardAction.done();

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: Focus(focusNode: node, child: const TextField()))),
      );
      node.requestFocus();
      await tester.pump();
      expect(node.hasFocus, true);

      action.onTap?.call(node);
      await tester.pump();
      expect(node.hasFocus, false);

      node.dispose();
    });

    test('done action has default label "Done"', () {
      final action = KeyboardAction.done();
      expect(action.label, 'Done');
    });

    test('next action has icon', () {
      final action = KeyboardAction.next();
      expect(action.icon, isNotNull);
    });

    test('prev action has icon', () {
      final action = KeyboardAction.prev();
      expect(action.icon, isNotNull);
    });

    test('clear action clears the controller', () {
      final ctrl = TextEditingController(text: 'hello');
      final action = KeyboardAction.clear(ctrl);
      expect(ctrl.text, 'hello');
      action.onTap?.call(FocusNode());
      expect(ctrl.text, '');
      ctrl.dispose();
    });

    test('custom action fires onTap', () {
      int count = 0;
      final action = KeyboardAction.custom(label: 'Go', onTap: () => count++);
      action.onTap?.call(FocusNode());
      expect(count, 1);
    });
  });

  // ── KeyboardConfig ──────────────────────────────────────────────────────────────
  group('KeyboardConfig', () {
    test('defaults: iOS=true, Android=false, Web=false', () {
      const config = KeyboardConfig();
      expect(config.showOnIOS, true);
      expect(config.showOnAndroid, false);
      expect(config.showOnWeb, false);
    });

    test('allPlatforms preset enables all', () {
      expect(KeyboardConfig.allPlatforms.showOnAndroid, true);
      expect(KeyboardConfig.allPlatforms.showOnIOS, true);
      expect(KeyboardConfig.allPlatforms.showOnWeb, true);
    });

    test('default height is 44', () {
      expect(const KeyboardConfig().height, 44);
    });

    test('custom backgroundColor can be set', () {
      const config = KeyboardConfig(backgroundColor: Colors.red);
      expect(config.backgroundColor, Colors.red);
    });
  });

  // ── KeyboardActionsBar widget ────────────────────────────────────────────
  group('KeyboardActionsBar widget', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KeyboardActionsBar(
              child: Text('hello'),
            ),
          ),
        ),
      );
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('KeyboardField renders child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardActionsBar(
              child: KeyboardField(
                actions: [KeyboardAction.done()],
                child: const TextField(),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('toolbar is not shown when keyboard is not visible',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KeyboardActionsBar(
              config: KeyboardConfig.allPlatforms,
              child: TextField(),
            ),
          ),
        ),
      );
      await tester.pump();
      // Toolbar should not render when keyboard is not visible
      expect(find.byType(KeyboardToolbarView), findsNothing);
    });
  });

  // ── KeyboardToolbarView ────────────────────────────────────────────────────
  group('KeyboardToolbarView', () {
    testWidgets('renders action buttons', (tester) async {
      final node = FocusNode();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardToolbarView(
              actions: [
                KeyboardAction.done(),
                KeyboardAction.custom(label: 'Custom', onTap: () {}),
              ],
              currentFocus: node,
              config: const KeyboardConfig(),
            ),
          ),
        ),
      );
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
      node.dispose();
    });

    testWidgets('footer is shown when provided', (tester) async {
      final node = FocusNode();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KeyboardToolbarView(
              actions: [KeyboardAction.done()],
              currentFocus: node,
              config: const KeyboardConfig(),
              footer: const Text('my footer'),
            ),
          ),
        ),
      );
      expect(find.text('my footer'), findsOneWidget);
      node.dispose();
    });
  });
}
