import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../qlevar_router.dart';
import './routes_tree/routes_tree.dart';

/// The parser for QRouter
class QRouteInformationParser extends RouteInformationParser<MatchContext> {
  const QRouteInformationParser();
  @override
  Future<MatchContext> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      return SynchronousFuture(null);
    }
    return MatchContext(fullPath: routeInformation.location);
  }

  @override
  RouteInformation restoreRouteInformation(MatchContext match) =>
      RouteInformation(location: QR.currentRoute.fullPath);
}
