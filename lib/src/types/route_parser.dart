import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';

/// The parser for QRouter
class QRouteInformationParser extends RouteInformationParser<String> {
  const QRouteInformationParser();

  // not async, it would wrap the SynchronousFuture in a Future and the
  // route would be handled one frame later
  @override
  Future<String> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture(routeInformation.uri.toString());

  @override
  RouteInformation restoreRouteInformation(String configuration) =>
      RouteInformation(uri: Uri.parse(QR.currentPath));
}
