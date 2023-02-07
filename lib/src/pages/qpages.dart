import 'package:flutter/cupertino.dart';

const defaultDuration = Duration(milliseconds: 300);

/// Set the page type for this route
/// you can use [QMaterialPage], [QCupertinoPage] or [QPlatformPage]
/// The default is [QPlatformPage]
abstract class QPage {
  const QPage(this.fullScreenDialog, this.maintainState, this.restorationId);

  final bool fullScreenDialog;
  final bool maintainState;
  final String? restorationId;
}

/// This type will set the page type as [MaterialPage]
class QMaterialPage extends QPage {
  const QMaterialPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    this.addMaterialWidget = true,
    String? restorationId,
  }) : super(fullscreenDialog, maintainState, restorationId);

  final bool addMaterialWidget;
}

/// This type will set the page type as [CupertinoPage]
class QCupertinoPage extends QPage {
  const QCupertinoPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    String? restorationId,
    this.title,
  }) : super(fullscreenDialog, maintainState, restorationId);

  final String? title;
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
  const QCustomPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    this.barrierColor,
    this.barrierDismissible,
    this.barrierLabel,
    this.opaque,
    this.transitionDuration = defaultDuration,
    this.reverseTransitionDuration = defaultDuration,
    this.transitionsBuilder,
    String? restorationId,
    this.withType,
  }) : super(fullscreenDialog, maintainState, restorationId);

  final Color? barrierColor;
  final bool? barrierDismissible;
  final String? barrierLabel;
  final bool? opaque;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final RouteTransitionsBuilder? transitionsBuilder;
  final QCustomPage? withType;
}

class QSlidePage extends QCustomPage {
  const QSlidePage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    Color? barrierColor,
    bool? barrierDismissible,
    String? barrierLabel,
    bool? opaque,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
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
          transitionDuration: transitionDuration ?? defaultDuration,
          reverseTransitionDuration:
              reverseTransitionDuration ?? defaultDuration,
          restorationId: restorationId,
          withType: withType,
        );

  final Curve? curve;
  final Offset? offset;
}

class QFadePage extends QCustomPage {
  const QFadePage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    Color? barrierColor,
    bool? barrierDismissible,
    String? barrierLabel,
    bool? opaque,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
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
            transitionDuration: transitionDuration ?? defaultDuration,
            reverseTransitionDuration:
                reverseTransitionDuration ?? defaultDuration,
            restorationId: restorationId,
            withType: withType);

  final Curve? curve;
}
