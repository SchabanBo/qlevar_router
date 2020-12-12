import 'package:flutter/widgets.dart';
import 'route.dart';

class QRouteInformationParser extends RouteInformationParser<QUri> {
  @override
  Future<QUri> parseRouteInformation(RouteInformation routeInformation) async =>
      QUri(routeInformation.location);

  @override
  RouteInformation restoreRouteInformation(QUri uri) =>
      RouteInformation(location: Uri.decodeComponent(uri.uri.toString()));
}
