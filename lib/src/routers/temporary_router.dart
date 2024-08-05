import 'dart:async';

import 'package:flutter/material.dart';

import '../../qlevar_router.dart';

/// A widget that creates a temporary navigator with the given routes.
/// This will create temporary router to use it in a specific part of the app.
/// The router will be created with the given routes and will be disposed when the widget is disposed.
///
/// LImitation: URL Navigation: The temporary router will not function if the user directly types the path into the URL.
/// This limitation arises because the temporary router is designed to exist only within the widget tree
/// and is destroyed when the widget is removed.
class TemporaryQRouter extends StatefulWidget {
  /// The path for the temporary route.
  final String path;

  /// The name of the temporary route.
  final String? name;

  /// An array of routes to be managed by this temporary router.
  final List<QRoute> routes;

  /// The initial path to be shown when the router is initialized.
  final String? initPath;

  /// A list of observers to be attached to the navigator.
  final List<NavigatorObserver>? observers;

  /// A restorationId to be attached to the navigator.
  final String? restorationId;

  const TemporaryQRouter({
    required this.path,
    required this.routes,
    this.name,
    this.initPath,
    this.observers,
    this.restorationId,
    super.key,
  });

  @override
  State<TemporaryQRouter> createState() => _TemporaryQRouterState();
}

class _TemporaryQRouterState extends State<TemporaryQRouter> {
  final _completer = Completer<Widget>();
  final _treeAdjuster = _TreeAdjuster();
  final originalRoute = QR.currentPath;
  late final name = widget.name ?? widget.path;

  @override
  void initState() {
    _createNavigator();
    super.initState();
  }

  void _createNavigator() async {
    _treeAdjuster.adjust(name, widget.routes);
    QR.treeInfo.namePath[name] = widget.path;
    final router = await QR.createNavigator(
      name,
      observers: widget.observers,
      restorationId: widget.restorationId,
      initPath: widget.initPath,
      routes: widget.routes,
    );
    _completer.complete(router);
    QR.activeNavigatorName = name;
  }

  @override
  void dispose() {
    _removeNavigator();
    super.dispose();
  }

  void _removeNavigator() async {
    await QR.removeNavigator(name);
    QR.treeInfo.namePath.remove(name);
    QR.activeNavigatorName = QRContext.rootRouterName;
    _treeAdjuster.reset();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      QR.updateUrlInfo(originalRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _completer.future,
      builder: (context, snapshot) {
        return snapshot.hasData ? snapshot.data! : QR.settings.initPage;
      },
    );
  }
}

class _TreeAdjuster {
  final newTree = <String, String>{};
  final oldTree = <String, String>{};

  void adjust(String name, List<QRoute> routes) {
    oldTree.addAll(QR.treeInfo.namePath);
    _adjust(routes, name);
    _checkTree();
  }

  void _adjust(List<QRoute> routes, String currentPath) {
    for (var route in routes) {
      newTree[route.name ?? route.path] = '$currentPath${route.path}';
      if (route.children != null) {
        _adjust(route.children!, '$currentPath${route.path}');
      }
    }
  }

  void _checkTree() {
    final currentTree = QR.treeInfo.namePath;
    for (var key in newTree.keys) {
      if (currentTree.containsKey(key)) {
        currentTree.remove(key);
      }
    }
  }

  void reset() {
    QR.treeInfo.namePath.clear();
    QR.treeInfo.namePath.addAll(oldTree);
  }
}
