import '../qlevar_router.dart';
import 'routes_tree/routes_tree.dart';

class QNavigator {
  /// The internal route Tree
  final RoutesTree _routesTree = RoutesTree();

  void setTree(List<QRouteBase> routes) => _routesTree.buildTree(routes);

  void toPath(String path, QNavigationMode mode) {
    final match = _routesTree.getMatch(path);
    match.setNavigationMode(mode ?? QNavigationMode());
    updatePath(match);
  }

  void toName(String name, Map<String, dynamic> params, QNavigationMode mode) {
    final match = _routesTree.getNamedMatch(name, params);
    match.setNavigationMode(mode ?? QNavigationMode());
    updatePath(match);
  }

  MatchContext getMatch(String path) => _routesTree.getMatch(path);

  void updatePath(MatchContext match) {}
}
