import 'package:qlevar_router/src/navigator/router_controller.dart';

import 'match_context.dart';
import 'navigator/navigation_mode.dart';
import 'navigator/navigation_type.dart';
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
    return QRouterDelegate(
        _controller.createRouterController(-1, 'Root', match, false));
  }

  void toPath(
      String path, NavigationType type, bool justUrl, QNaviagtionMode mode) {
    final match = _getMatch(path);
    setNewMatch(match, type, justUrl, mode);
  }

  void toName(String name, Map<String, dynamic> params, NavigationType type,
      bool justUrl, QNaviagtionMode mode) {
    final match = _routesTree.getNamedMatch(name, params);
    setNewMatch(match, type, justUrl, mode, name: name);
  }

  void setNewMatch(MatchContext match, NavigationType type, bool justUrl,
      QNaviagtionMode mode,
      {String name}) {
    if (mode != null &&
        name != null &&
        mode.type == QNaviagtionModeType.ChildOf) {
      match = getMatchName(name, match);
    }
    _controller.setNewMatch(match, type, justUrl, mode);
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
