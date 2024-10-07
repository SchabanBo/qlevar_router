import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../controllers/qrouter_controller.dart';

/// A Router used with Nested Navigation to show the child for the navigation
class QRouter extends StatefulWidget {
  /// the Navigation key for this [Navigator]
  final navKey = GlobalKey<NavigatorState>();

  final QRouterController _controller;

  late final List<NavigatorObserver> observers = [_controller.observer];

  QRouter(
    this._controller, {
    List<NavigatorObserver>? observers,
    super.key,
    this.restorationId,
  }) {
    if (observers != null) {
      this.observers.addAll(observers);
    }
  }

  /// Restoration ID to save and restore the state of the navigator, including
  /// its history.
  final String? restorationId;

  /// Get the name for the current child
  /// This is the name which define in [QRoute.name] if it is null [QRoute.path]
  /// Will be returned
  String get routeName =>
      _controller.currentRoute.name ?? _controller.currentRoute.path;

  /// Get the [QNavigator] for this [QRouter] to add or remove pages to it.
  QNavigator get navigator => _controller;

  @override
  State createState() => _QRouterState();
}

class _QRouterState extends State<QRouter> {
  @override
  void initState() {
    super.initState();
    if (widget._controller.isDisposed) return;
    widget._controller.addListener(update);
    widget._controller.navKey = widget.navKey;
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var scopId = widget.restorationId;
    if (scopId == null && QR.settings.autoRestoration) {
      scopId = 'router:${widget._controller.key.name}';
    }

    return Navigator(
      key: widget.navKey,
      observers: widget.observers,
      pages: widget._controller.pages,
      onDidRemovePage: (_) {
        QR.back();
      },
      restorationScopeId: scopId,
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
