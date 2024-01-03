// ignore_for_file: constant_identifier_names

/// This represent the pop result
enum PopResult {
  /// The pop end successfully
  Popped,

  /// Cannot pop
  NotPopped,

  /// The Can pop in the middleware returns false
  NotAllowedToPop,

  /// This means that the navigator has a [PopupRoute] and it was dismissed and no other page was popped
  PopupDismissed,
}

/// Use this to define what to do when page already is in the stack
enum PageAlreadyExistAction {
  /// Remove the page from the stack
  Remove,

  /// Bring the page to the top of the stack, if the page has any children in the stack, bring the first child to the top
  BringToTop,

  /// Just bring the page to the top of the stack, and ignore any children of this page in the stack
  IgnoreChildrenAndBringToTop,
}
