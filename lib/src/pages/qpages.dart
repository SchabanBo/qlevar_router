import 'package:flutter/cupertino.dart';

/// Set the page type for this route
/// you can use [QMaterialPage], [QCupertinoPage] or [QPlatformPage]
/// The default is [QPlatformPage]
abstract class QPage {
  final bool maintainState;
  final bool fullscreenDialog;
  final String? restorationId;
  const QPage(this.fullscreenDialog, this.maintainState, this.restorationId);
}

/// This type will set the page type as [MaterialPage]
class QMaterialPage extends QPage {
  const QMaterialPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    String? restorationId,
  }) : super(fullscreenDialog, maintainState, restorationId);
}

/// This type will set the page type as [CupertinoPage]
class QCupertinoPage extends QPage {
  final String? title;
  const QCupertinoPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    String? restorationId,
    this.title,
  }) : super(fullscreenDialog, maintainState, restorationId);
}

/// This type will determinade the page type based on the platfrom
///  and gives [QMaterialPage] or [QCupertinoPage]
class QPlatformPage extends QPage {
  const QPlatformPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    String? restorationId,
  }) : super(fullscreenDialog, maintainState, restorationId);
}

/// Give a custom animation for the page.
class QCustomPage extends QPage {
  final int transitionDurationmilliseconds;
  final int reverseTransitionDurationmilliseconds;
  final bool? opaque;
  final bool? barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final RouteTransitionsBuilder? transitionsBuilder;

  const QCustomPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.opaque,
    int? reverseTransitionDurationmilliseconds,
    int? transitionDurationmilliseconds,
    this.transitionsBuilder,
    String? restorationId,
  })  : reverseTransitionDurationmilliseconds =
            reverseTransitionDurationmilliseconds ?? 300,
        transitionDurationmilliseconds = transitionDurationmilliseconds ?? 300,
        super(fullscreenDialog, maintainState, restorationId);
}

class QSlidePage extends QCustomPage {
  final Offset? offset;
  final Curve? curve;
  const QSlidePage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    Color? barrierColor,
    bool? barrierDismissible,
    String? barrierLabel,
    bool? opaque,
    int? reverseTransitionDurationmilliseconds,
    int? transitionDurationmilliseconds,
    String? restorationId,
    this.curve,
    this.offset,
  }) : super(
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          opaque: opaque,
          reverseTransitionDurationmilliseconds:
              reverseTransitionDurationmilliseconds,
          transitionDurationmilliseconds: transitionDurationmilliseconds,
          restorationId: restorationId,
        );
}
