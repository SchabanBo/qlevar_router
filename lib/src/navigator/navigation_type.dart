/// Define how you want the navigation to react.
enum NavigationType {
  /// place the new page on the top of the stack.
  Push,

  /// remove all page from the stack and place this on on the top.
  ReplaceAll,

  /// replace the last page with this page.
  ReplaceLast,

  /// Pop all page unit you get this page in the stack
  /// if the page doesn't exist in the stack push in on the top.
  /// This is the default type to navigation.
  PopUntilOrPush,
}
