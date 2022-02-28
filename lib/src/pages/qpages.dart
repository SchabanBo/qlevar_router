import 'package:flutter/cupertino.dart';

/// Set the page type for this route
/// you can use [QMaterialPage], [QCupertinoPage] or [QPlatformPage]
/// The default is [QPlatformPage]
abstract class QPage {
  final bool maintainState;
  final bool fullScreenDialog;
  final String? restorationId;
  const QPage(this.fullScreenDialog, this.maintainState, this.restorationId);
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

/// This type will determinate the page type based on the platform
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
  final int transitionDurationMilliseconds;
  final int reverseTransitionDurationMilliseconds;
  final bool? opaque;
  final bool? barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final RouteTransitionsBuilder? transitionsBuilder;
  final QCustomPage? withType;

  const QCustomPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.opaque,
    int? reverseTransitionDurationMilliseconds,
    int? transitionDurationMilliseconds,
    this.transitionsBuilder,
    String? restorationId,
    this.withType,
  })  : reverseTransitionDurationMilliseconds =
            reverseTransitionDurationMilliseconds ?? 300,
        transitionDurationMilliseconds = transitionDurationMilliseconds ?? 300,
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
    int? reverseTransitionDurationMilliseconds,
    int? transitionDurationMilliseconds,
    String? restorationId,
    QCustomPage? withType,
    this.curve,
    this.offset,
  }) : super(
          barrierColor: barrierColor,
          barrierDismissible: barrierDismissible,
          barrierLabel: barrierLabel,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
          opaque: opaque,
          reverseTransitionDurationMilliseconds:
              reverseTransitionDurationMilliseconds,
          transitionDurationMilliseconds: transitionDurationMilliseconds,
          restorationId: restorationId,
          withType: withType,
        );
}

class QFadePage extends QCustomPage {
  final Curve? curve;
  const QFadePage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    Color? barrierColor,
    bool? barrierDismissible,
    String? barrierLabel,
    bool? opaque,
    int? reverseTransitionDurationMilliseconds,
    int? transitionDurationMilliseconds,
    String? restorationId,
    QCustomPage? withType,
    this.curve,
  }) : super(
            barrierColor: barrierColor,
            barrierDismissible: barrierDismissible,
            barrierLabel: barrierLabel,
            fullscreenDialog: fullscreenDialog,
            maintainState: maintainState,
            opaque: opaque,
            reverseTransitionDurationMilliseconds:
                reverseTransitionDurationMilliseconds,
            transitionDurationMilliseconds: transitionDurationMilliseconds,
            restorationId: restorationId,
            withType: withType);
}
