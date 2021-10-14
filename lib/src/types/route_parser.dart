import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../qlevar_router.dart';

/// The parser for QRouter
class QRouteInformationParser extends RouteInformationParser<String> {
  const QRouteInformationParser();
  @override
  Future<String> parseRouteInformation(
          RouteInformation routeInformation) async =>
      SynchronousFuture(
          Uri.decodeFull(routeInformation.location ?? '/').toString());

  @override
  RouteInformation restoreRouteInformation(String match) =>
      RouteInformation(location: Uri.encodeFull(QR.currentPath).toString());
}
