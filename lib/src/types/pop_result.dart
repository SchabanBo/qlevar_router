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
