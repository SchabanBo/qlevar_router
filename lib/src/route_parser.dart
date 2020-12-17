import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'routes_tree.dart';
import 'types.dart';

class QRouteInformationParser extends RouteInformationParser<MatchRoute> {
  final String _parent;

  const QRouteInformationParser({@required String parent}) : _parent = parent;

  @override
  Future<MatchRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    QR.log(
        // ignore: lines_longer_than_80_chars
        'Searching for Route: ${routeInformation.location} for parent $_parent');
    if (routeInformation.location == null) {
      return SynchronousFuture(null);
    }
    return QR.findMatch(routeInformation.location, parent: _parent);
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
