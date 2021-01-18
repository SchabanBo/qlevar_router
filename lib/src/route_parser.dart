import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'qr.dart';

/// The parser for QRouter
class QRouteInformationParser extends RouteInformationParser<String> {
  const QRouteInformationParser();
  @override
  Future<String> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      return SynchronousFuture(null);
    }
    return routeInformation.location;
  }

  @override
  RouteInformation restoreRouteInformation(String match) =>
      RouteInformation(location: QR.currentRoute.fullPath);
}
