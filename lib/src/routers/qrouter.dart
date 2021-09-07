import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';

/// A Router used with Nested Navigation to show the child for the navigation
class QRouter extends StatefulWidget {
  /// the Navigation key for this [Navigator]
  final navKey = GlobalKey<NavigatorState>();

  final QRouterController _controller;

  QRouter(this._controller);

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
    widget._controller.addListener(update);
    widget._controller.navKey = widget.navKey;
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navKey,
      pages: widget._controller.pages,
      onPopPage: (route, result) {
        widget._controller.removeLast();
        return false;
      },
    );
  }

  @override
  void dispose() {
    if (!widget._controller.isDisposed) {
      widget._controller.removeListener(update);
    }
    super.dispose();
  }
}
