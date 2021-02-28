import 'match_context.dart';
import 'navigator/navigation_mode.dart';
import 'navigator/navigation_request.dart';
import 'navigator/navigator_controller.dart';
import 'qr.dart';
import 'router_delegate.dart';
import 'routes_tree/routes_tree.dart';
import 'types.dart';

class QRController {
  /// The internal route Tree
  final _routesTree = RoutesTree();
  final _controller = QNavigatorController();

  QNavigatorController get navigatorController => _controller;

  void setTree(List<QRouteBase> routes) => _routesTree.buildTree(routes);
  void logTree() => _routesTree.logTree();

  QRouterDelegate createDelegate(String initRoute) {
    final match = _getMatch(initRoute);
    match.treeUpdated();
    QR.history.add(NavigatioRequest(initRoute, null, false, null, null));
    return QRouterDelegate(
        _controller.createRouterController(-1, 'Root', match, false));
  }

  void toPath(NavigatioRequest request) => setNewMatch(request);

  void toName(NavigatioRequest request, Map<String, dynamic> params) {
    request.path = _routesTree.findPathFromName(request.name, params);
    setNewMatch(request);
  }

  QNaviagtionMode _getNaviagtionMode(MatchContext match) {
    final newRoute = match.getNewMatch();
    return newRoute?.route?.navigationMode ?? QR.settings.defaultNavigationMode;
  }

  void setNewMatch(NavigatioRequest request) {
    var match = _getMatch(request.path);
    request.mode ??= _getNaviagtionMode(match);
    if (request.mode != null &&
        request.name != null &&
        request.mode.type == QNaviagtionModeType.ChildOf) {
      match = getMatchName(request.name, match);
    }
    _controller.setNewMatch(match, request);
  }

  MatchContext getMatchName(String name, MatchContext match) {
    if (name == match.route.name) {
      return match;
    }
    if (match.childContext != null) {
      return getMatchName(name, match.childContext);
    }
    throw Exception('No match with name $name found');
  }

  MatchContext _getMatch(String path) {
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    QR.log('Navigate to $path');
    final match = _routesTree.getMatch(path);
    return match;
  }
}
