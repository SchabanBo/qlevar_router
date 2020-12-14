import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'routes_tree.dart';
import 'types.dart';

class QRouteInformationParser extends RouteInformationParser<MatchRoute> {
  @override
  Future<MatchRoute> parseRouteInformation(
          RouteInformation routeInformation) async =>
      SynchronousFuture(QR.findMatch(routeInformation.location ?? '/'));

  @override
  RouteInformation restoreRouteInformation(MatchRoute match) =>
      RouteInformation(location: match.route.fullPath);
}

class QRouteInformationProvider extends PlatformRouteInformationProvider {
  QRouteInformationProvider({String initialRoute})
      : super(
            initialRouteInformation: RouteInformation(location: initialRoute));
}
