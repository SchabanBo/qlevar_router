import 'package:flutter/widgets.dart';
import '../controllers/qrouter_controller.dart';

/// A Router used with Nested Navigation to show the child for the navigation
class QRouter extends StatefulWidget {
  /// the Navigation key for this [Navigator]
  final navKey = GlobalKey<NavigatorState>();

  final QRouterController _controller;

  final bool isDeclarative;

  QRouter(this._controller, {this.isDeclarative = false});

  /// Get the name for the current child
  /// This is the name whih define in [QRoute.name] if it is null [QRoute.path]
  /// Will be returned
  String get routeName =>
      _controller.currentRoute.name ?? _controller.currentRoute.path;

  /// Get the [QNavigator] for this [QRouter] to add or remove pages to it.
  QNavigator get navigator => _controller;

  @override
  _QRouterState createState() => _QRouterState();
}

class _QRouterState extends State<QRouter> {
  @override
  void initState() {
    super.initState();
    widget._controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: widget.navKey,
        pages: widget._controller.pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          if (widget._controller.canPop) {
            widget._controller.removeLast();
            return true;
          }
          return false;
        },
      );

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}
