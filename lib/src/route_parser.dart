import 'package:flutter/widgets.dart';
import 'types.dart';

class QRouteInformationParser extends RouteInformationParser<QUri> {
  @override
  Future<QUri> parseRouteInformation(RouteInformation routeInformation) async =>
      QUri(routeInformation.location);

  @override
  RouteInformation restoreRouteInformation(QUri uri) =>
      RouteInformation(location: Uri.decodeComponent(uri.uri.toString()));
}

class QRouteInformationProvider extends PlatformRouteInformationProvider {
  QRouteInformationProvider({String initialRoute})
      : super(
            initialRouteInformation: RouteInformation(location: initialRoute));
}
