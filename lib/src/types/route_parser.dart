import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';

/// The parser for QRouter
class QRouteInformationParser extends RouteInformationParser<String> {
  const QRouteInformationParser();
  @override
  Future<String> parseRouteInformation(
          RouteInformation routeInformation) async =>
      SynchronousFuture(routeInformation.uri.toString());

  @override
  RouteInformation restoreRouteInformation(String configuration) =>
      RouteInformation(uri: Uri.parse(QR.currentPath));
}
