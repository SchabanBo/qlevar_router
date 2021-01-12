import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../qlevar_router.dart';
import './routes_tree/routes_tree.dart';

/// The parser for QRouter
class QRouteInformationParser extends RouteInformationParser<MatchContext> {
  final MatchContext Function(String) _getMatch;
  const QRouteInformationParser(this._getMatch);
  @override
  Future<MatchContext> parseRouteInformation(
      RouteInformation routeInformation) async {
    QR.log(
        // ignore: lines_longer_than_80_chars
        'Searching for Route: ${routeInformation.location}');
    if (routeInformation.location == null) {
      return SynchronousFuture(null);
    }
    return _getMatch(routeInformation.location);
  }

  @override
  RouteInformation restoreRouteInformation(MatchContext match) =>
      RouteInformation(location: QR.currentRoute.fullPath);
}
