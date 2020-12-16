import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'routes_tree.dart';
import 'types.dart';

class QRouteInformationParser extends RouteInformationParser<MatchRoute> {
  final String _parent;
  final String _key;

  const QRouteInformationParser({@required String parent, @required String key})
      : _parent = parent,
        _key = key;

  @override
  Future<MatchRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    QR.log(
        // ignore: lines_longer_than_80_chars
        'Searching for Route: ${routeInformation.location} for parent $_key');
    if (routeInformation.location == null) {
      return SynchronousFuture(null);
    }
    var routeMatch =
        QR.findMatch('$_parent${routeInformation.location ?? ''}');
            
    // Search for the matching key for this parser.
    while (true) {
      if (routeMatch.route.key == _key) {
        return SynchronousFuture(routeMatch);
      }
      if (routeMatch.route.parent == null) {
        break;
      } else {
        routeMatch = MatchRoute(route: routeMatch.route.parent);
      }
    }

    return SynchronousFuture(null);
  }

  @override
  RouteInformation restoreRouteInformation(MatchRoute match) =>
      RouteInformation(location: match.route.fullPath);
}

class QRouteInformationProvider extends PlatformRouteInformationProvider {
  QRouteInformationProvider({String initialRoute})
      : super(
            initialRouteInformation: RouteInformation(location: initialRoute));
}
