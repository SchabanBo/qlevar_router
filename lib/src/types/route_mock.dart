import '../routes/qroute.dart';

/// This class is used for testing,so you don't have to add routes to your test
/// Just set the `QR.settings.mockRoute` and the package will use this RouteMock
/// to check if the test is navigated to a page or not.
abstract class RouteMock {
  QRoute? mockPath(String path);
  String? mockName(String name);
}
