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

  Map<String, dynamic> get params => currentRoute.params;

  final _controller = QRController();

  QRouterDelegate router(List<QRouteBase> routes, {String initRoute = ''}) {
    _controller.setTree(routes);
    return _controller.createDelegate(initRoute);
  }

  /// Get the RouteInformationParser
  QRouteInformationParser routeParser() => const QRouteInformationParser();

  /// Navigate to new page with [path]
  void to(String path, {QNavigationMode mode}) =>
      _controller.toPath(path, mode);

  /// Navigate to new page with [Name]
  /// Give the name of the route and the [params] to apply
  void toName(String name,
          {Map<String, dynamic> params, QNavigationMode mode}) =>
      _controller.toName(name, params ?? <String, dynamic>{}, mode);

  // back to previous page
  void back() => _controller.pop();

  /// wirte log
  void log(String mes, {bool isDebug = false}) {
    if (settings.enableLog && (!isDebug || settings.enableDebugLog)) {
      print('Qlevar-Route: $mes');
    }
  }
}

/// Define how you want the navgiation to react.
class QNavigationMode {
  /// The navigation type
  final NavigationType type;

  QNavigationMode({this.type = NavigationType.ReplaceLast});
}

/// Navigation type, used when navigation to new page.
/// [Push] place the new page on the top of the stack.
/// and don't remove the last one.
/// [PopUnitOrPush] Pop all page unit you get this page in the stack
/// if the page doesn't exist in the stack push in on the top.
/// [ReplaceLast] replace the last page with this page.
/// [ReplaceAll] remove all page from the stack and place this on on the top.
enum NavigationType {
  Push,
  PopUnitOrPush,
  ReplaceLast,
  ReplaceAll,
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
}
