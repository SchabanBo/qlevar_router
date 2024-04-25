import '../routes/qroute.dart';

/// This class is used for testing,so you don't have to add routes to your test
/// Just set the `QR.settings.mockRoute` and the package will use this RouteMock
/// to check if the test is navigated to a page or not.
abstract class RouteMock {
  /// This method is used to mock the name of the route.
  /// It should return the path of the route. Then the [mockPath] will be called to get the route.
  String? mockName(String name);

  /// This method is used to mock the path of the route.
  /// It should return the the route.
  /// If this method returns null, then the package will use the [QR.settings.notFound] route.
  QRoute? mockPath(String path);
}
