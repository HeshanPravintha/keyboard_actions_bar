/// Controls what happens when the user taps outside the keyboard toolbar area.
enum TapOutsideBehavior {
  /// No overlay — default Flutter behavior.
  none,

  /// Tapping outside dismisses the keyboard. Blocks gestures to widgets below.
  opaqueDismiss,

  /// Tapping outside dismisses the keyboard. Gestures pass through to widgets below
  /// (scroll, tap on list items still work).
  translucentDismiss,
}
