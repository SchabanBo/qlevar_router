import 'package:flutter/widgets.dart';

class QDialogRoute<T> extends PopupRoute<T> {
  QDialogRoute({
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    String? barrierLabel,
    Color barrierColor = const Color(0x80000000),
    Duration transitionDuration = const Duration(milliseconds: 200),
    RouteTransitionsBuilder? transitionBuilder,
    RouteSettings? settings,
  })  : widget = pageBuilder,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _barrierColor = barrierColor,
        _transitionDuration = transitionDuration,
        _transitionBuilder = transitionBuilder,
        super(settings: settings);

  @override
  bool get barrierDismissible => _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;

  @override
  Color get barrierColor => _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;

  final Color _barrierColor;
  final String? _barrierLabel;
  final RoutePageBuilder widget;
  final bool _barrierDismissible;
  final Duration _transitionDuration;
  final RouteTransitionsBuilder? _transitionBuilder;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      _transitionBuilder == null
          ? FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
              child: child)
          : _transitionBuilder!(context, animation, secondaryAnimation, child);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: widget(context, animation, secondaryAnimation),
      );
}
