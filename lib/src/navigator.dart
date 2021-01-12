import 'package:flutter/widgets.dart';

import '../qlevar_router.dart';
import 'routes_tree/routes_tree.dart';

class QNavigator {
  /// The internal route Tree
  final RoutesTree _routesTree = RoutesTree();
  final rootKey = GlobalKey<NavigatorState>();
  Function notify;

  void setTree(List<QRouteBase> routes) => _routesTree.buildTree(routes);

  void toPath(String path, QNavigationMode mode) {
    final match = _routesTree.getMatch(path);
    updatePath(match, mode);
  }

  void toName(String name, Map<String, dynamic> params, QNavigationMode mode) {
    final match = _routesTree.getNamedMatch(name, params);
    updatePath(match, mode);
  }

  MatchContext getMatch(String path) => _routesTree.getMatch(path);
  void updatePath(MatchContext match, QNavigationMode mode) {}

  bool pop() {}

  Page<dynamic> initRoute(String initRoute) {}
}
