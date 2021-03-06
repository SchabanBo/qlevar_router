import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:qlevar_router/qlevar_router.dart';

/// The parser for QRouter
class QRouteInformationParser extends RouteInformationParser<String> {
  const QRouteInformationParser();
  @override
  Future<String> parseRouteInformation(
          RouteInformation routeInformation) async =>
      SynchronousFuture(routeInformation.location ?? '/');

  @override
  RouteInformation restoreRouteInformation(String match) =>
      RouteInformation(location: QR.curremtPath);
}
