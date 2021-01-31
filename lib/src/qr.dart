import 'navigator/navigation_mode.dart';

import 'qr_controller.dart';
import 'route_parser.dart';
import 'router_delegate.dart';
import 'types.dart';

/// Qlevar Router.
// ignore: non_constant_identifier_names
final QR = _QRContext();

/// The main class of qlevar-router
class _QRContext {
  /// Settings for the package
  final settings = QrSettings();

  /// list of string for the paths that has been called.
  final history = <String>[];

  /// The information for the current route
  /// here you can find the params for the current route
  /// or even the fullpath
  final _QCurrentRoute currentRoute = _QCurrentRoute();

  /// The route params
  Map<String, dynamic> get params => currentRoute.params;

  final _controller = QRController();

  /// Get the router for the app.
  QRouterDelegate router(List<QRouteBase> routes, {String initRoute = ''}) {
    _controller.setTree(routes);
    return _controller.createDelegate(initRoute);
  }

  /// Log the project tree structure
  void logTree() => _controller.logTree();

  /// Get the RouteInformationParser
  QRouteInformationParser routeParser() => const QRouteInformationParser();

  /// Navigate to new page with [path]
  void to(String path, {NavigationType type}) => _controller.toPath(path, type);

  /// Navigate to new page with [Name]
  /// Give the name of the route and the [params] to apply
  void toName(String name,
          {Map<String, dynamic> params, NavigationType type}) =>
      _controller.toName(name, params ?? <String, dynamic>{}, type);

  // back to previous page
  bool back() => _controller.pop();

  /// wirte log
  void log(String mes, {bool isDebug = false}) {
    if (settings.enableLog && (!isDebug || settings.enableDebugLog)) {
      settings.logger('Qlevar-Route: $mes');
    }
  }
}

/// The cureent route inforamtion
class _QCurrentRoute {
  /// The current full path
  String fullPath = '';

  /// The params for the current route
  Map<String, dynamic> params = {};
}

/// The package settings
class QrSettings {
  bool enableLog = true;
  bool enableDebugLog = false;
  Function(String) logger = print;
}
