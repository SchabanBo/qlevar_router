import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../pages/page_creator.dart';
import '../pages/qpage_internal.dart';

/// The Declarative page builder
/// it gives you the state and take the pages to show
typedef DeclarativeBuilder = List<QDRoute> Function();

/// Declarative Router
/// Navigate between your pages with a state update
class QDeclarative extends StatefulWidget {
  /// The key you got from the `QRoute.declarativeBuilder`.
  final QKey routeKey;

  /// The pages to build with the declarative
  final DeclarativeBuilder builder;

  QDeclarative({
    required this.routeKey,
    required this.builder,
  }) : super(key: Key(routeKey.name));

  @override
  QDeclarativeController createState() =>
      // ignore: no_logic_in_create_state
      QR.createDeclarativeRouterController(routeKey);
}

class QDeclarativeController extends State<QDeclarative> {
  /// the Navigation key for this [Navigator]
  final navKey = GlobalKey<NavigatorState>();

  /// The routes of the pages in the stack, the last one is on the top
  final routes = <QDRoute>[];

  final _pages = <QPageInternal>[];

  void update() {
    if (mounted) setState(() {});
  }

  /// Did the pop proceed. False when the top route has no [QDRoute.onPop]
  bool pop() {
    final route = routes.last;
    final pageType = route.pageType ?? QR.settings.pagesType;
    if (!pageType.canPop) {
      // blocked, like Flutter does for the page
      pageType.onPopInvoked?.call(false, null);
      return true;
    }
    final onPop = route.onPop;
    if (onPop == null) return false;
    final pop = onPop();
    update();
    return pop ?? true;
  }

  /// Flutter already popped [page] (swipe back, the AppBar back button,
  /// Navigator.pop), let the state follow
  void _onDidRemovePage(Page page) {
    final index = _pages.indexWhere((p) => identical(p, page));
    // removed by [updatePages], the state already changed. Older Flutter
    // versions report these too, popping again would unwind the whole flow
    if (index == -1) return;
    final onPop = routes[index].onPop;
    // Navigator does not show it anymore. Without onPop the state does not
    // change, and the next rebuild adds it again if its `when` is still true
    _pages.removeRange(index, _pages.length);
    routes.removeRange(index, routes.length);
    if (onPop == null) return;
    onPop();
    update();
  }

  @override
  Widget build(BuildContext context) {
    updatePages();
    return Navigator(
      key: navKey,
      pages: List.unmodifiable(_pages),
      onDidRemovePage: _onDidRemovePage,
    );
  }

  void updatePages() {
    final newRoute = widget.builder().firstWhere(
          (e) => e.when(),
          orElse: () => throw StateError(
              'No route has returned true as [when] result from QDeclarative.builder'),
        );
    final index = _pages.indexWhere((e) => e.matchKey.hasName(newRoute.name));

    if (index == -1) {
      _pages.add(_createPage(newRoute));
      routes.add(newRoute);
    } else {
      _pages.removeRange(index + 1, _pages.length);
      routes.removeRange(index + 1, routes.length);
      // the newest builder, page type and callbacks of this route. The same
      // key updates the page instead of pushing a new one
      _pages[index] = _createPage(newRoute, pageKey: _pages[index].key);
      routes[index] = newRoute;
    }
  }

  QPageInternal _createPage(QDRoute route, {LocalKey? pageKey}) =>
      DeclarativePageCreator(route.name, QKey(route.name), route.pageType,
              pageKey: pageKey)
          .createWithChild(route.builder());
}
