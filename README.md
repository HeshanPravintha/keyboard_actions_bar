<h1 align="center">
  keyboard_actions_bar
  <br>
</h1>

<h4 align="center">
  A fully customizable Flutter keyboard toolbar — Done / Next / Prev / Clear / InsertAt / Custom actions above the soft keyboard, with zero FocusNode boilerplate, tap-outside dismiss, footer widgets, custom keyboard panels, smooth animation, haptic feedback, and Material 3 theming out of the box.
</h4>

<p align="center">
  <a href="https://pub.dev/packages/keyboard_actions_bar">
    <img src="https://img.shields.io/pub/v/keyboard_actions_bar.svg" alt="Pub Version">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  </a>
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-3.16%2B-54C5F8?logo=flutter" alt="Flutter 3.16+">
  </a>
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web-lightgrey" alt="Platform">
  </a>
</p>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#actions">Actions</a> •
  <a href="#keyboardfield">KeyboardField</a> •
  <a href="#keyboardbaritem">KeyboardBarItem</a> •
  <a href="#footer-widget">Footer Widget</a> •
  <a href="#custom-keyboard-panel">Custom Keyboard Panel</a> •
  <a href="#keyboardconfig">KeyboardConfig</a> •
  <a href="#license">License</a>
</p>

<p align="center">
  <img src="https://github.com/HeshanPravintha/keyboard_actions_bar/blob/main/screenshots/Keyboard_Actions_Bar_Demo.gif" alt="keyboard_actions_bar demo" />
</p>

## Key Features

* Zero FocusNode boilerplate — wrap any `TextField` in `KeyboardField`, done
* `kbField()` record — couples `FocusNode + TextEditingController` in one line
* 6 built-in actions — `done`, `next`, `prev`, `clear`, `insertAt`, `custom`
* Done callback — fire logic before the keyboard closes
* Per-field toolbar control — hide bar, align buttons, skip disabled fields
* Tap-outside dismiss — opaque or translucent overlay
* Global Done override — custom widget or text for the Done button
* Footer widget — suggestion chips, emoji picker, live character counter
* Custom keyboard panels — replace the system keyboard with your own UI
* Config-list style — `KeyboardBarItem` for separate FocusNode management
* Smooth slide animation — configurable duration & curve
* Haptic feedback on every button tap
* Material 3 themed — auto-adapts to your `ColorScheme`, dark mode aware
* Samsung / OEM keyboard fix — deferred focus-loss prevents IME bounce bugs
* Android `adjustResize` support — works with the default Flutter manifest


## Installation

```yaml
dependencies:
  keyboard_actions_bar: ^1.0.0
```

```bash
flutter pub get
```

## Import

```dart
import 'package:keyboard_actions_bar/keyboard_actions_bar.dart';
```

## Quick Start

Wrap your `Scaffold` body in `KeyboardActionsBar` and each `TextField` in `KeyboardField`:

```dart
Scaffold(
  body: KeyboardActionsBar(
    child: ListView(
      children: [
        KeyboardField(
          child: TextField(decoration: InputDecoration(labelText: 'Name')),
        ),
        KeyboardField(
          child: TextField(decoration: InputDecoration(labelText: 'Email')),
        ),
      ],
    ),
  ),
)
```

**That's it.** Prev / Next / Done appear automatically above the keyboard on iOS.  
To also show on Android or Web:

```dart
KeyboardActionsBar(
  config: KeyboardConfig.allPlatforms,
  child: ...,
)
```

## Actions

### All 6 built-in actions

```dart
KeyboardAction.done()               // closes keyboard
KeyboardAction.next()               // move focus to next field ↓
KeyboardAction.prev()               // move focus to previous field ↑
KeyboardAction.clear(controller)    // clears a TextEditingController
KeyboardAction.insertAt(controller) // inserts '@' at cursor (email helper)
KeyboardAction.custom(...)          // fully custom — label, icon, or widget
```

| Factory | Default UI | Behaviour |
|---|---|---|
| `done()` | `"Done"` text | `node.unfocus()` |
| `next()` | `keyboard_arrow_down` | moves focus forward |
| `prev()` | `keyboard_arrow_up` | moves focus backward |
| `clear(ctrl)` | `backspace_outlined` | clears controller |
| `insertAt(ctrl)` | `"Insert @"` | inserts char at cursor |
| `custom(...)` | your choice | any callback |

### Override defaults

```dart
KeyboardAction.done(label: 'Submit')
KeyboardAction.done(onTap: () => submitForm())   // fires BEFORE keyboard closes
KeyboardAction.next(icon: Icons.arrow_forward_ios)
KeyboardAction.prev(icon: Icons.arrow_back_ios)
KeyboardAction.clear(ctrl, icon: Icons.delete_outline)
KeyboardAction.insertAt(ctrl, char: '#', label: 'Hashtag')
```

<details><summary>Custom action examples</summary>

```dart
// Text label
KeyboardAction.custom(
  label: 'Save draft',
  onTap: () => saveDraft(),
)

// Icon button
KeyboardAction.custom(
  icon: Icons.emoji_emotions_outlined,
  onTap: () => controller.text += ' 😊',
)

// Fully custom widget (receives the FocusNode)
KeyboardAction.custom(
  onTap: () {},
  builder: (context, focusNode) => GestureDetector(
    onTap: () {
      focusNode.unfocus();
      submitForm();
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Submit',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
    ),
  ),
)
```

</details>

## kbField() — Field Record

`kbField()` couples a `FocusNode` and `TextEditingController` into a single Dart 3 record so they always travel together.

```dart
// Declare
final _name  = kbField(debugLabel: 'name');
final _email = kbField(debugLabel: 'email');
final _phone = kbField(debugLabel: 'phone');

// Dispose — one loop for all fields
@override
void dispose() {
  for (final f in [_name, _email, _phone]) {
    f.focus.dispose();
    f.ctrl.dispose();
  }
  super.dispose();
}

// Use
TextField(focusNode: _name.focus, controller: _name.ctrl)
```

**Without `kbField()`** you need 8 separate declarations + 8 dispose calls for 4 fields. With it — 4 declarations + one loop.

## KeyboardActionBuilders

Helper actions that work directly with `KbField` records:

```dart
KeyboardActionBuilders.insertAt(_email)              // inserts '@' using _email.ctrl
KeyboardActionBuilders.insertAt(_email, char: '#')   // any character
KeyboardActionBuilders.clear(_phone)                 // clears _phone.ctrl
```

## KeyboardField

Per-field wrapper — co-locates toolbar config with the field itself.

```dart
KeyboardField(
  actions: [
    KeyboardAction.prev(),
    KeyboardAction.next(),
    KeyboardAction.insertAt(ctrl),
    KeyboardAction.clear(ctrl),
    KeyboardAction.done(onTap: () => validate()),
  ],
  footer: MyFooterWidget(),                          // optional widget below toolbar
  displayActionBar: true,                            // false = hide toolbar row
  toolbarAlignment: MainAxisAlignment.end,           // button alignment
  child: TextField(controller: ctrl),
)
```

### KeyboardField properties

| Property | Type | Default | Description |
|---|---|---|---|
| `actions` | `List<KeyboardAction>?` | config default | Buttons shown in the toolbar |
| `footer` | `Widget?` | `null` | Widget below the toolbar row |
| `focusNode` | `FocusNode?` | auto-created | Provide your own node if needed |
| `displayActionBar` | `bool` | `true` | Show/hide the toolbar row |
| `toolbarAlignment` | `MainAxisAlignment` | `end` | Button row alignment |

## KeyboardBarItem

For when you prefer a separate config list (similar to `keyboard_actions` pub.dev style).  
Each item owns a `FocusNode` — pass `item.focusNode` to its `TextField`.

```dart
final _nameItem  = KeyboardBarItem(
  actions: [KeyboardAction.prev(), KeyboardAction.next(), KeyboardAction.done()],
);
final _emailItem = KeyboardBarItem(
  actions: [
    KeyboardAction.prev(),
    KeyboardAction.insertAt(_emailCtrl),
    KeyboardAction.done(),
  ],
);
```

<details><summary>Full KeyboardBarItem example</summary>

```dart
// Declare items
final _nameItem  = KeyboardBarItem(
  actions: [KeyboardAction.prev(), KeyboardAction.next(), KeyboardAction.done()],
);
final _emailItem = KeyboardBarItem(
  actions: [
    KeyboardAction.prev(),
    KeyboardAction.insertAt(_emailCtrl),
    KeyboardAction.done(),
  ],
  toolbarAlignment: MainAxisAlignment.spaceBetween,
);
final _phoneItem = KeyboardBarItem(
  actions: [KeyboardAction.prev(), KeyboardAction.clear(_phoneCtrl), KeyboardAction.done()],
);
final _noteItem = KeyboardBarItem(
  actions: [KeyboardAction.prev(), KeyboardAction.done()],
  enabled: false,           // skip this field — no toolbar shown when focused
  displayActionBar: false,  // hide toolbar row (footer still shows if set)
);

// Dispose
@override
void dispose() {
  for (final item in [_nameItem, _emailItem, _phoneItem, _noteItem]) {
    item.dispose();
  }
  super.dispose();
}

// Wire up
KeyboardActionsBar(
  config: KeyboardConfig.allPlatforms,
  items: [_nameItem, _emailItem, _phoneItem, _noteItem],
  child: ListView(children: [
    TextField(focusNode: _nameItem.focusNode,  controller: _nameCtrl),
    TextField(focusNode: _emailItem.focusNode, controller: _emailCtrl),
    TextField(focusNode: _phoneItem.focusNode, controller: _phoneCtrl),
    TextField(focusNode: _noteItem.focusNode,  controller: _noteCtrl),
  ]),
)
```

</details>

### KeyboardBarItem properties

| Property | Type | Default | Description |
|---|---|---|---|
| `focusNode` | `FocusNode?` | auto-created | Pass to the matching `TextField` |
| `actions` | `List<KeyboardAction>?` | config default | Toolbar buttons for this field |
| `footer` | `Widget?` | `null` | Widget below the toolbar row |
| `enabled` | `bool` | `true` | `false` = skip, no toolbar shown |
| `displayActionBar` | `bool` | `true` | Show/hide the toolbar row |
| `toolbarAlignment` | `MainAxisAlignment` | `end` | Button row alignment |

## Footer Widget

Attach any widget **below** the toolbar row.

<details><summary>Live character counter</summary>

```dart
KeyboardField(
  actions: [KeyboardAction.prev(), KeyboardAction.done()],
  footer: ValueListenableBuilder<TextEditingValue>(
    valueListenable: controller,
    builder: (context, value, _) {
      final count = value.text.length;
      return Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Text(
          '$count / 120',
          textAlign: TextAlign.end,
          style: TextStyle(
            color: count > 100
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 12,
          ),
        ),
      );
    },
  ),
  child: TextField(controller: controller, maxLines: 3, maxLength: 120),
)
```

</details>

<details><summary>Suggestion chips</summary>

```dart
KeyboardField(
  footer: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Row(
      children: ['flutter', 'dart', 'mobile', 'ios', 'android']
          .map((tag) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text('#$tag'),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => controller.text += ' #$tag',
                ),
              ))
          .toList(),
    ),
  ),
  child: TextField(controller: controller),
)
```

</details>

## Custom Keyboard Panel

Replace the system keyboard with your own UI using `KeyboardCustomInput<T>`.

```dart
final _dateNotifier = ValueNotifier<DateTime>(DateTime.now());
final _dateItem = KeyboardBarItem(
  displayActionBar: false,
  footer: MyDatePickerPanel(notifier: _dateNotifier),
);

KeyboardActionsBar(
  items: [_dateItem],
  child: KeyboardCustomInput<DateTime>(
    focusNode: _dateItem.focusNode,
    notifier: _dateNotifier,
    height: 48,
    builder: (context, value, hasFocus) => Text(
      '${value.day}/${value.month}/${value.year}',
      style: TextStyle(
        fontSize: 16,
        color: hasFocus
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
    ),
  ),
)
```

<details><summary>Build a custom keyboard panel</summary>

```dart
class MyDatePickerPanel extends StatefulWidget {
  final ValueNotifier<DateTime> notifier;
  const MyDatePickerPanel({required this.notifier});
  @override
  State<MyDatePickerPanel> createState() => _MyDatePickerPanelState();
}

class _MyDatePickerPanelState extends State<MyDatePickerPanel>
    with KeyboardCustomPanelMixin<DateTime> {
  @override
  ValueNotifier<DateTime> get notifier => widget.notifier;

  @override
  Widget build(BuildContext context) => CalendarDatePicker(
    initialDate: notifier.value,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    onDateChanged: (date) => updateValue(date), // pushes to notifier
  );
}
```

</details>

## KeyboardConfig

Controls the toolbar appearance and behaviour globally.

```dart
KeyboardActionsBar(
  config: const KeyboardConfig(
    showOnAndroid: true,
    showOnIOS: true,
    showOnWeb: false,
    height: 48,
    backgroundColor: Colors.white,
    showSeparator: true,
    separatorColor: Colors.grey,
    elevation: 2,
    animationDuration: Duration(milliseconds: 200),
    animationCurve: Curves.easeOut,
    defaultDoneButtonText: 'Submit',
    defaultDoneWidget: MyDoneButton(),
    tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
  ),
  child: ...,
)
```

<details><summary>All KeyboardConfig properties</summary>

| Property | Type | Default | Description |
|---|---|---|---|
| `showOnAndroid` | `bool` | `false` | Show on Android |
| `showOnIOS` | `bool` | `true` | Show on iOS |
| `showOnWeb` | `bool` | `false` | Show on Web / Desktop |
| `height` | `double` | `44` | Toolbar row height (px) |
| `backgroundColor` | `Color?` | `surfaceContainerHigh` | Toolbar background |
| `showSeparator` | `bool` | `true` | Thin line above toolbar |
| `separatorColor` | `Color?` | `outlineVariant` | Separator line color |
| `elevation` | `double` | `0` | Drop shadow above toolbar |
| `animationDuration` | `Duration` | `150ms` | Slide-in / slide-out speed |
| `animationCurve` | `Curve` | `Curves.easeOut` | Animation easing |
| `defaultActions` | `List<KeyboardAction>?` | `[prev, next, done]` | Fallback when a field has no actions |
| `defaultDoneButtonText` | `String` | `'Done'` | Rename the Done button globally |
| `defaultDoneWidget` | `Widget?` | `null` | Replace Done button widget globally |
| `tapOutsideBehavior` | `TapOutsideBehavior` | `none` | Tap-outside dismiss behaviour |

</details>

## TapOutsideBehavior

```dart
KeyboardConfig(tapOutsideBehavior: TapOutsideBehavior.none)               // default — no overlay
KeyboardConfig(tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss)      // tap dismisses, blocks gestures below
KeyboardConfig(tapOutsideBehavior: TapOutsideBehavior.translucentDismiss) // tap dismisses, gestures pass through
```

| Value | Behaviour |
|---|---|
| `none` | Default Flutter behaviour — no tap-outside handling |
| `opaqueDismiss` | Tapping outside closes keyboard. Blocks scroll/tap below |
| `translucentDismiss` | Tapping outside closes keyboard. Scrolling and taps still work |

## Requirements

| | Version |
|---|---|
| Flutter | `>= 3.16.0` |
| Dart | `>= 3.0.0` |

No Android manifest changes needed. Works with the default `android:windowSoftInputMode="adjustResize"`.

## License

MIT
