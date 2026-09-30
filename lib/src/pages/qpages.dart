import 'package:flutter/cupertino.dart';

const defaultDuration = Duration(milliseconds: 300);

/// Set the page type for this route
/// you can use [QMaterialPage], [QCupertinoPage] or [QPlatformPage]
/// The default is [QPlatformPage]
abstract class QPage {
  const QPage(
    this.fullScreenDialog,
    this.maintainState,
    this.restorationId, {
    this.canPop = true,
    this.onPopInvoked,
  });

  final bool fullScreenDialog;
  final bool maintainState;
  final String? restorationId;

  /// Set it to false to block popping this page: iOS swipe back, the AppBar
  /// back button, `Navigator.maybePop`, the Android back button and
  /// `QR.back()`, see [Page.canPop].
  final bool canPop;

  /// Called when this page was popped, or a pop was blocked because
  /// [canPop] is false, see [Page.onPopInvoked].
  final PopInvokedWithResultCallback<dynamic>? onPopInvoked;
}

/// This type will set the page type as [MaterialPage]
class QMaterialPage extends QPage {
  const QMaterialPage({
    bool fullscreenDialog = false,
    bool maintainState = true,
    this.addMaterialWidget = true,
    String? restorationId,
    super.canPop,
    super.onPopInvoked,
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
    super.canPop,
    super.onPopInvoked,
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
    super.canPop,
    super.onPopInvoked,
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
    super.canPop,
    super.onPopInvoked,
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
    super.fullscreenDialog,
    super.maintainState,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.opaque,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    super.restorationId,
    super.withType,
    super.canPop,
    super.onPopInvoked,
    this.curve,
    this.offset,
  }) : super(
          transitionDuration: transitionDuration ?? defaultDuration,
          reverseTransitionDuration:
              reverseTransitionDuration ?? defaultDuration,
        );

  final Curve? curve;
  final Offset? offset;
}

class QFadePage extends QCustomPage {
  const QFadePage({
    super.fullscreenDialog,
    super.maintainState,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.opaque,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    super.restorationId,
    super.withType,
    super.canPop,
    super.onPopInvoked,
    this.curve,
  }) : super(
            transitionDuration: transitionDuration ?? defaultDuration,
            reverseTransitionDuration:
                reverseTransitionDuration ?? defaultDuration);

  final Curve? curve;
}

class QModalBottomSheetPage extends QPage {
  const QModalBottomSheetPage({
    this.isScrollControlled = false,
    this.isDismissible = true,
    @Deprecated('Not used, use isDismissible') this.barrierDismissible = true,
    this.enableDrag = true,
    this.useSafeArea = false,
    this.showDragHandle,
    this.barrierLabel,
    this.barrierOnTapHint,
    this.anchorPoint,
    String? restorationId,
    super.canPop,
    super.onPopInvoked,
  }) : super(false, false, restorationId);
  final bool isScrollControlled;
  final bool isDismissible;
  @Deprecated('Not used, use isDismissible')
  final bool barrierDismissible;
  final bool enableDrag;
  final bool useSafeArea;
  final bool? showDragHandle;
  final String? barrierLabel;
  final String? barrierOnTapHint;
  final Offset? anchorPoint;
}
