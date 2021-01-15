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

  QRouterDelegate createDelegate(String initRoute) {
    final match = _getMatch(initRoute);
    match.treeUpdated();
    final request = _controller.createRequest(match, -1, 'Root');
    final page = _controller.createState(match, request: request);
    return QRouterDelegate(this, page, request);
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
    QR.log('Navigate to $path');
    final match = _routesTree.getMatch(path);
    return match;
  }
}
