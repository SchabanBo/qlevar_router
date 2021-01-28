import 'package:flutter/cupertino.dart';

/// Set the page type for this route
/// you can use [QRMaterialPage], [QRCupertinoPage] or [QRPlatformPage]
/// The default is [QRPlatformPage]
abstract class QRPage {
  final bool maintainState;
  final bool fullscreenDialog;
  final String restorationId;
  const QRPage(this.fullscreenDialog, this.maintainState, this.restorationId);
}

/// This type will set the page type as [MaterialPage]
class QRMaterialPage extends QRPage {
  const QRMaterialPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    String restorationId,
  }) : super(fullscreenDialog, maintainState, restorationId);
}

/// This type will set the page type as [CupertinoPage]
class QRCupertinoPage extends QRPage {
  final String title;
  const QRCupertinoPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    this.title,
    String restorationId,
  }) : super(fullscreenDialog, maintainState, restorationId);
}

/// This type will determinade the page type based on the platfrom
///  and gives [QRMaterialPage] or [QRCupertinoPage]
class QRPlatformPage extends QRPage {
  const QRPlatformPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    String restorationId,
  }) : super(fullscreenDialog, maintainState, restorationId);
}

/// Give a custom animation for the page.
class QRCustomPage extends QRPage {
  final int transitionDurationmilliseconds;
  final int reverseTransitionDurationmilliseconds;
  final bool opaque;
  final bool barrierDismissible;
  final Color barrierColor;
  final String barrierLabel;
  final RouteTransitionsBuilder transitionsBuilder;

  const QRCustomPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    String restorationId,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.opaque,
    int reverseTransitionDurationmilliseconds,
    int transitionDurationmilliseconds,
    this.transitionsBuilder,
  })  : reverseTransitionDurationmilliseconds =
            reverseTransitionDurationmilliseconds ?? 300,
        transitionDurationmilliseconds = transitionDurationmilliseconds ?? 300,
        super(fullscreenDialog, maintainState, restorationId);
}

class QRSlidePage extends QRCustomPage {
  final Offset offset;
  final Curve curve;
  const QRSlidePage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    String restorationId,
    Color barrierColor,
    bool barrierDismissible,
    String barrierLabel,
    bool opaque,
    int reverseTransitionDurationmilliseconds,
    int transitionDurationmilliseconds,
    this.curve,
    this.offset,
  }) : super(
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          restorationId: restorationId,
          opaque: opaque,
          reverseTransitionDurationmilliseconds:
              reverseTransitionDurationmilliseconds,
          transitionDurationmilliseconds: transitionDurationmilliseconds,
        );
}
