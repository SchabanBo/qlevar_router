import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../qlevar_router.dart';

// ignore: prefer_mixin
class UrlController extends ChangeNotifier with WidgetsBindingObserver {
  RouteInformation currentRoute = RouteInformation(location: '');
  UrlController();
  @override
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    _handel(routeInformation);
    return true;
  }

  @override
  Future<bool> didPushRoute(String route) async {
    _handel(RouteInformation(location: route));
    return true;
  }

  @override
  Future<bool> didPopRoute() async {
    return QR.back();
  }

  void _handel(RouteInformation route) {
    if (currentRoute == route) {
      return;
    }
    currentRoute = route;
    notifyListeners();
  }

  void updateUrl(RouteInformation route) {
    currentRoute = route;
    SystemNavigator.routeInformationUpdated(
      location: currentRoute.location!,
      state: currentRoute.state,
    );
  }
}
