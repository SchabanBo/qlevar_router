import 'helpers/widgets/stack_tree.dart';
import 'navigator/navigation_mode.dart';
import 'navigator/navigation_request.dart';
import 'navigator/navigation_type.dart';
import 'navigator/router_controller.dart';
import 'qparams.dart';
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
  final history = <NavigatioRequest>[];

  /// The information for the current route
  /// here you can find the params for the current route
  /// or even the fullpath
  final _QCurrentRoute currentRoute = _QCurrentRoute();

  /// The route params
  QParams get params => currentRoute.params;

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
  void to(
    String path, {
    NavigationType type,
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      _controller.toPath(NavigatioRequest(path, null, justUrl, mode, type));

  void push(
    String path, {
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      to(path, justUrl: justUrl, mode: mode, type: NavigationType.Push);

  void replaceAll(
    String path, {
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      to(path, justUrl: justUrl, mode: mode, type: NavigationType.ReplaceAll);

  void replaceLast(
    String path, {
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      to(path, justUrl: justUrl, mode: mode, type: NavigationType.ReplaceLast);

  void popUntilOrPush(
    String path, {
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      to(path,
          justUrl: justUrl, mode: mode, type: NavigationType.PopUntilOrPush);

  /// Navigate to new page with [Name]
  /// Give the name of the route and the [params] to apply
  void toName(
    String name, {
    Map<String, dynamic> params,
    NavigationType type,
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      _controller.toName(NavigatioRequest(null, name, justUrl, mode, type),
          params ?? <String, dynamic>{});

  void pushName(
    String name, {
    Map<String, dynamic> params,
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      toName(name,
          params: params,
          justUrl: justUrl,
          mode: mode,
          type: NavigationType.Push);

  void replaceAllName(
    String name, {
    Map<String, dynamic> params,
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      toName(name,
          params: params,
          justUrl: justUrl,
          mode: mode,
          type: NavigationType.ReplaceAll);

  void replaceLastName(
    String name, {
    Map<String, dynamic> params,
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      toName(name,
          params: params,
          justUrl: justUrl,
          mode: mode,
          type: NavigationType.ReplaceLast);

  void popUntilOrPushName(
    String name, {
    Map<String, dynamic> params,
    bool justUrl = false,
    QNaviagtionMode mode,
  }) =>
      toName(name,
          params: params,
          justUrl: justUrl,
          mode: mode,
          type: NavigationType.PopUntilOrPush);

  // back to previous page
  bool back() => _controller.navigatorController.back();

  RouterController routerOf(String name) =>
      _controller.navigatorController.routerOf(name);

  DebugStackTree getStackTreeWidget() =>
      _controller.navigatorController.getStackTreeWidget();

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
  final params = QParams();
}

/// The package settings
class QrSettings {
  bool enableLog = true;
  bool enableDebugLog = false;
  // Add the default not found page path without slash.
  String notFoundPagePath = 'notfound';
  QNaviagtionMode defaultNavigationMode = QNaviagtionMode.asChild();
  Function(String) logger = print;
}
