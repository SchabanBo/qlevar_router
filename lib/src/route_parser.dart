import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../qlevar_router.dart';
import 'types.dart';

class QRouteInformationParser extends RouteInformationParser<MatchContext> {
  final String _parent;

  const QRouteInformationParser({@required String parent}) : _parent = parent;

  @override
  Future<MatchContext> parseRouteInformation(
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
  RouteInformation restoreRouteInformation(MatchContext match) =>
      RouteInformation(location: match.fullPath);
}

class QRouteInformationProvider extends PlatformRouteInformationProvider {
  QRouteInformationProvider({String initialRoute})
      : super(
            initialRouteInformation: RouteInformation(location: initialRoute));
}
