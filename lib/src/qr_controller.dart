import '../qlevar_router.dart';
import 'navigator/src/navigator_controller.dart';
import 'router_delegate.dart';
import 'routes_tree/src/match_context.dart';
import 'routes_tree/src/routes_tree.dart';

class QRController {
  /// The internal route Tree
  final _routesTree = RoutesTree();
  final _controller = QNavigatorController();

  void setTree(List<QRouteBase> routes) => _routesTree.buildTree(routes);

  void toPath(String path, QNavigationMode mode) {
    final match = _getMatch(path);
    updatePath(match, mode);
  }

  void toName(String name, Map<String, dynamic> params, QNavigationMode mode) {
    final match = _routesTree.getNamedMatch(name, params);
    updatePath(match, mode);
  }

  bool pop() => _controller.pop();

  void updatePath(MatchContext match, QNavigationMode mode) {}

  MatchContext _getMatch(String path) {
    QR.log('Navigate to $path');
    final match = _routesTree.getMatch(path);
    match.printTree();
    return match;
  }

  QRouterDelegate createDelegate(String initRoute) {
    final match = _getMatch(initRoute);
    final delegate = QRouterDelegate(this, _controller, match);
    return delegate;
  }
}
