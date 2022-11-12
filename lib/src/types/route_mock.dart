import '../routes/qroute.dart';

/// This class is used for testing,so you don't have to add routes to your test
/// Just set the `QR.settings.mockRoute` and the package will use this RouteMock
/// to check if the test is navigated to a page or not.
abstract class RouteMock {
  QRoute? mockPath(String path);
  String? mockName(String name);
}

/// Use this class to mock named route
/// ```dart
/// class MyRouteMock extends NamedRouteMock {
///  @override
///  QRoute? mockRoute(String name) {
///    if (name == AppRoutes.app) {
///      return QRoute(path: '/', builder: () => const SizedBox());
///    }
///    return null;
///  }
///}
///// Set the class to use it
/// QR.settings.mockRoute = MyRouteMock();
///```
abstract class NamedRouteMock implements RouteMock {
  QRoute? _route;
  QRoute? mockRoute(String name);
  @override
  QRoute? mockPath(String path) {
    if (path != hashCode.toString()) {
      return null;
    }
    final result = _route;
    _route = null;
    return result;
  }

  @override
  String? mockName(String name) {
    _route = mockRoute(name);
    return hashCode.toString();
  }
}

typedef RouteMocker = QRoute? Function(String);
