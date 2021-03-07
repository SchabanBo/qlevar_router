import '../pages/page_creator.dart';
import '../pages/qpage_internal.dart';
import '../routes/qroute_internal.dart';
import 'middleware_controller.dart';

class PagesController {
  final routes = <QRouteInternal>[];
  final pages = <QPageInternal>[];

  bool exist(QRouteInternal route) =>
      routes.any((element) => element.key.isSame(route.key));

  void add(QRouteInternal route) {
    routes.add(route);
    MiddlewareController(route).runOnEnter();
    pages.add(PageCreator(route).create());
  }

  void removeLast() {
    final route = routes.last;
    MiddlewareController(route).runOnExit();
    routes.removeLast();
    pages.removeLast();
  }

  void removeIndex(int index) {
    final route = routes[index];
    MiddlewareController(route).runOnExit();
    routes.removeAt(index);
    pages.removeAt(index);
  }
}
