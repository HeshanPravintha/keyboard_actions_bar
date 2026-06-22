import 'package:flutter/material.dart';
import 'package:keyboard_actions_bar/keyboard_actions_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'keyboard_actions_bar',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const _HomePage(),
      );
}

// ── Home ──────────────────────────────────────────────────────────────────────

class _HomePage extends StatefulWidget {
  const _HomePage();
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final _done       = TextEditingController();
  final _nav1       = TextEditingController();
  final _nav2       = TextEditingController();
  final _nav3       = TextEditingController();
  final _clear      = TextEditingController();
  final _insertAt   = TextEditingController();
  final _customLbl  = TextEditingController();
  final _customIcon = TextEditingController();
  final _customBldr = TextEditingController();
  final _counter    = TextEditingController();
  final _chips      = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _done, _nav1, _nav2, _nav3, _clear, _insertAt,
      _customLbl, _customIcon, _customBldr, _counter, _chips,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('keyboard_actions_bar'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: KeyboardActionsBar(
          config: KeyboardConfig.allPlatforms,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // ── 1. done() ─────────────────────────────────────────────
              _Sep('1. KeyboardAction.done()'),
              KeyboardField(
                actions: [KeyboardAction.done()],
                child: _tf(_done, 'done — closes the keyboard'),
              ),

              // ── 2. next() / prev() ────────────────────────────────────
              _Sep('2. KeyboardAction.next() / prev()'),
              KeyboardField(
                actions: [KeyboardAction.next(), KeyboardAction.done()],
                child: _tf(_nav1, 'nav 1 — next only'),
              ),
              const SizedBox(height: 10),
              KeyboardField(
                actions: [
                  KeyboardAction.prev(),
                  KeyboardAction.next(),
                  KeyboardAction.done(),
                ],
                child: _tf(_nav2, 'nav 2 — prev + next'),
              ),
              const SizedBox(height: 10),
              KeyboardField(
                actions: [KeyboardAction.prev(), KeyboardAction.done()],
                child: _tf(_nav3, 'nav 3 — prev only'),
              ),

              // ── 3. clear(controller) ──────────────────────────────────
              _Sep('3. KeyboardAction.clear(controller)'),
              KeyboardField(
                actions: [
                  KeyboardAction.clear(_clear),
                  KeyboardAction.done(),
                ],
                child: _tf(_clear, 'clear — tap ⌫ to wipe field'),
              ),

              // ── 4. insertAt(controller) ───────────────────────────────
              _Sep('4. KeyboardAction.insertAt(controller)'),
              KeyboardField(
                actions: [
                  KeyboardAction.insertAt(_insertAt),
                  KeyboardAction.insertAt(_insertAt, char: '.com', label: '.com'),
                  KeyboardAction.done(),
                ],
                child: _tf(_insertAt, 'insertAt — "@" or ".com"',
                    type: TextInputType.emailAddress),
              ),

              // ── 5. custom(label:) ─────────────────────────────────────
              _Sep('5. KeyboardAction.custom(label:)'),
              KeyboardField(
                actions: [
                  KeyboardAction.custom(
                    label: '#tag',
                    onTap: () {
                      _customLbl.text += '#tag ';
                      _customLbl.selection = TextSelection.collapsed(
                          offset: _customLbl.text.length);
                    },
                  ),
                  KeyboardAction.done(),
                ],
                child: _tf(_customLbl, 'custom label — tap "#tag"'),
              ),

              // ── 6. custom(icon:) ──────────────────────────────────────
              _Sep('6. KeyboardAction.custom(icon:)'),
              KeyboardField(
                actions: [
                  KeyboardAction.custom(
                    icon: Icons.emoji_emotions_outlined,
                    onTap: () {
                      _customIcon.text += '😊';
                      _customIcon.selection = TextSelection.collapsed(
                          offset: _customIcon.text.length);
                    },
                  ),
                  KeyboardAction.custom(
                    icon: Icons.send_outlined,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Sent: "${_customIcon.text}"')),
                      );
                    },
                  ),
                  KeyboardAction.done(),
                ],
                child: _tf(_customIcon, 'custom icon — 😊 emoji / ✈ send'),
              ),

              // ── 7. custom(builder:) ───────────────────────────────────
              _Sep('7. KeyboardAction.custom(builder:)'),
              KeyboardField(
                actions: [
                  KeyboardAction.custom(
                    onTap: () {},
                    builder: (ctx, node) => GestureDetector(
                      onTap: () {
                        node.unfocus();
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Submitted: "${_customBldr.text}"')),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(ctx).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Theme.of(ctx).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                child: _tf(_customBldr, 'custom builder — full widget button'),
              ),

              // ── 8. live character counter ─────────────────────────────
              _Sep('8. footer — live character counter'),
              KeyboardField(
                actions: [KeyboardAction.done()],
                footer: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _counter,
                  builder: (ctx, val, _) {
                    final n = val.text.length;
                    return Container(
                      width: double.infinity,
                      color: Theme.of(ctx)
                          .colorScheme
                          .surfaceContainerHighest
                          .withOpacity(.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: Text(
                        '$n / 80',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12,
                          color: n > 60
                              ? Theme.of(ctx).colorScheme.error
                              : Theme.of(ctx).colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                ),
                child: TextField(
                  controller: _counter,
                  maxLength: 80,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'counter (80 chars max)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    counterText: '',
                  ),
                ),
              ),

              // ── 9. suggestion chips ───────────────────────────────────
              _Sep('9. footer — suggestion chips'),
              KeyboardField(
                actions: [KeyboardAction.done()],
                footer: Builder(
                  builder: (ctx) => Container(
                    color: Theme.of(ctx)
                        .colorScheme
                        .surfaceContainerHighest
                        .withOpacity(.5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['flutter', 'dart', 'mobile', 'ios', 'android']
                            .map((t) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: ActionChip(
                                    label: Text('#$t'),
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      final s = _chips.text;
                                      final v = s.isEmpty ? '#$t' : '$s #$t';
                                      _chips
                                        ..text = v
                                        ..selection =
                                            TextSelection.collapsed(
                                                offset: v.length);
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                child: _tf(_chips, 'chips — tap to append'),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      );
}

// ── Helpers ───────────────────────────────────────────────────────────────────

TextField _tf(
  TextEditingController ctrl,
  String label, {
  TextInputType? type,
}) =>
    TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );

class _Sep extends StatelessWidget {
  final String label;
  const _Sep(this.label);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 8),
        child: Row(children: [
          Expanded(
              child: Divider(
                  color: Theme.of(context).colorScheme.outlineVariant)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
            ),
          ),
          Expanded(
              child: Divider(
                  color: Theme.of(context).colorScheme.outlineVariant)),
        ]),
      );
}
