/// This represent the pop result
// ignore_for_file: constant_identifier_names

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

  /// Just bring the page to the top of the stack
  BringToTop,
}
