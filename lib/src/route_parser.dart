import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../qlevar_router.dart';
import 'types.dart';

/// A delegate that is used by the [Router] widget to parse a route information
/// into a configuration of type T.
///
/// This delegate is used when the [Router] widget is first built with initial
/// route information from [Router.routeInformationProvider] and any subsequent
/// new route notifications from it.
/// The [Router] widget calls the [parseRouteInformation]
/// with the route information from [Router.routeInformationProvider].
class QRouteInformationParser extends RouteInformationParser<MatchContext> {
  const QRouteInformationParser();
  @override
  Future<MatchContext> parseRouteInformation(
      RouteInformation routeInformation) async {
    QR.log(
        // ignore: lines_longer_than_80_chars
        'Searching for Route: ${routeInformation.location}');
    if (routeInformation.location == null) {
      return SynchronousFuture(null);
    }
    return QR.findMatch(routeInformation.location);
  }

  @override
  RouteInformation restoreRouteInformation(MatchContext match) =>
      RouteInformation(location: QR.currentRoute.fullPath);
}

class QRouteInformationProvider extends PlatformRouteInformationProvider {
  QRouteInformationProvider({String initialRoute})
      : super(
            initialRouteInformation: RouteInformation(location: initialRoute));
}
