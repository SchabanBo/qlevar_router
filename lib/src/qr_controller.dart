import 'match_context.dart';
import 'navigator/navigator_controller.dart';
import 'qr.dart';
import 'router_delegate.dart';
import 'routes_tree/routes_tree.dart';
import 'types.dart';

class QRController {
  /// The internal route Tree
  final _routesTree = RoutesTree();
  final _controller = QNavigatorController();

  void setTree(List<QRouteBase> routes) => _routesTree.buildTree(routes);
  void logTree() => _routesTree.logTree();

  QRouterDelegate createDelegate(String initRoute) {
    final match = _getMatch(initRoute);
    match.treeUpdated();
    return QRouterDelegate(
        _controller.createRouterController(-1, 'Root', match));
  }

  void toPath(String path, QNavigationMode mode) {
    final match = _getMatch(path);
    setNewMatch(match, mode);
  }

  void toName(String name, Map<String, dynamic> params, QNavigationMode mode) {
    final match = _routesTree.getNamedMatch(name, params);
    setNewMatch(match, mode);
  }

  bool pop() => _controller.pop();

  void setNewMatch(MatchContext match, QNavigationMode mode) =>
      _controller.setNewMatch(match, mode);

  MatchContext _getMatch(String path) {
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    QR.log('Navigate to $path');
    final match = _routesTree.getMatch(path);
    return match;
  }
}
