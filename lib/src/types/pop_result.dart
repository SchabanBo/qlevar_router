/// This represent the pop result
enum PopResult {
  /// The pop end successfully
  Poped,

  /// Cannot pop
  NotPoped,

  /// The Can pop in the middleware returens false
  NotAllowedToPop,

  /// when QR.back close a dialog
  DialogClosed,
}

/// Use this to define what to do when page already is in the stack
enum PageAlreadyExistAction {
  /// Remove the pagfe from the stack
  Remove,

  /// Just bring the page to the top of the stack
  BringToTop,

  /// Put the page at the top of the stack and remove other pages with the same name
  BringToTopAndRemoveOtherSameName,
}
