import 'package:flutter/material.dart';
import '../../qlevar_router.dart';

import '../routes/qdialog_route.dart';
import 'qoverlay.dart';

// Create a dialog to use with [QR]
class QDialog with QOverlay {
  /// It gives the pop action to close the dialog and takes the widget to show
  final Widget Function(VoidCallback pop) widget;
  final bool barrierDismissible = true;
  final Color? barrierColor;
  final bool useSafeArea = true;
  final bool useRootNavigator = true;
  final Duration? transitionDuration;
  final Curve? transitionCurve;
  final RouteSettings? routeSettings;
  final RouteTransitionsBuilder? transitionBuilder;

  /// The default [QDialog], it takes  [SimpleDialog], [AlertDialog], [Dialog]
  QDialog({
    required this.widget,
    this.barrierColor,
    this.transitionDuration,
    this.transitionCurve,
    this.routeSettings,
    this.transitionBuilder,
  });

  /// Create a simple dialog with just `title` and `text`
  factory QDialog.text({
    required Text text,
    Text? title,
    Color? barrierColor,
    Duration? transitionDuration,
    Curve? transitionCurve,
    RouteSettings? routeSettings,
    RouteTransitionsBuilder? transitionBuilder,
  }) {
    return QDialog(
        barrierColor: barrierColor,
        routeSettings: routeSettings,
        transitionBuilder: transitionBuilder,
        transitionCurve: transitionCurve,
        transitionDuration: transitionDuration,
        widget: (pop) => AlertDialog(
              title: title,
              content: text,
              actions: [TextButton(onPressed: pop, child: Text('Ok'))],
            ));
  }

  @override
  Future<T?> show<T>(
      {String? name, NavigatorState? state, BuildContext? context}) async {
    if (state == null || context == null) {
      if (name == null) {
        return await QR.rootNavigator.show(this);
      } else {
        return await QR.navigatorOf(name).show(this);
      }
    }

    return state.push<T>(QDialogRoute(
      pageBuilder: (buildContext, animation, secondaryAnimation) =>
          useSafeArea ? SafeArea(child: widget(state.pop)) : widget(state.pop),
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black54,
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
      transitionBuilder: transitionBuilder ??
          (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: transitionCurve ?? Curves.easeOutQuad,
              ),
              child: child,
            );
          },
      settings: routeSettings,
    ));
  }
}
