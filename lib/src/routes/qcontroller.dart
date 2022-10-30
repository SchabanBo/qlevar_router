import 'package:flutter/widgets.dart';

/// Basically [QController] holds the business logic required by the page.
/// Also only one [QController] should be associated with a page in general
class QController {
  /// Invoked when ever an [QController] is about to inject into the memory.
  /// Will be useful if we want to initialize some variables required by the [QController]
  @mustCallSuper
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrame());
  }

  /// Invoked one frame after [onInit] is called.
  /// Will be useful if we want to do async api requests & other stuff like that
  @mustCallSuper
  void onPostFrame() {}

  /// Invoked before removing the [QController] from the memory.
  /// Will be useful if we want to dispose the variables used by the [QController]
  /// like streams, events, controllers (like textEditingControllers & so),
  @mustCallSuper
  void onDispose() {}
}
