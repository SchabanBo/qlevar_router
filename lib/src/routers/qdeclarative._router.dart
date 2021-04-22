import 'package:flutter/widgets.dart';

import '../../qlevar_router.dart';
import '../pages/page_creator.dart';
import '../pages/qpage_internal.dart';
import '../routes/qdeclarative_route.dart';

/// The dcelatarive page builder
/// it gives you the state and take the pages to show
typedef DeclarativeBuilder = List<QDRoute> Function();

/// Delcarative Router
/// Navigate between your pages with a state update
class QDeclarative extends StatefulWidget {
  /// The key you got from the `QRoute.declarativeBuilder`.
  final QKey routeKey;

  final DeclarativeBuilder builder;

  QDeclarative({
    required this.routeKey,
    required this.builder,
  }) : super(key: Key(routeKey.name));

  @override
  QDeclarativeController createState() =>
      QR.createDeclarativeRouterController(routeKey);
}

class QDeclarativeController extends State<QDeclarative> {
  /// the Navigation key for this [Navigator]
  final navKey = GlobalKey<NavigatorState>();

  List<QDRoute>? routes;
  final _pages = <QPageInternal>[];

  void update() {
    setState(() {});
  }

  bool pop() {
    if (_pages.length <= 1 || routes!.last.onPop == null) {
      return false;
    }
    routes!.last.onPop!();
    update();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    updatePages();
    assert(_pages.isNotEmpty);
    print(_pages);
    print(navKey);
    return Navigator(
      key: navKey,
      pages: List.unmodifiable(_pages),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return pop();
      },
    );
  }

  void updatePages() {
    final newRoutes = widget.builder().where((e) => e.when()).toList();

    // for (var i = 0; i < newRoutes.length; i++) {
    //   // if (newRoutes[i].when() &&
    //   //     (i < newRoutes.length && !newRoutes[i + 1].when())) {
    //   //   newRoutes.removeRange(i, newRoutes.length - 1);
    //   //   break;
    //   // }
    //   if (!newRoutes[i].when()) {
    //     newRoutes.removeAt(i);
    //     i--;
    //   }
    // }

    // for (var i = newRoutes.length - 1; i >= 0; i--) {
    //   if (newRoutes[i].when()) {
    //     break;
    //   } else {
    //     newRoutes.removeAt(i);
    //   }
    // }

    // Remove old Pages
    for (var i = 0; i < _pages.length; i++) {
      if (i >= _pages.length) {
        break;
      }
      if (!newRoutes.any((e) => e.name == _pages[i].matchKey.name)) {
        _pages.removeAt(i);
        i--;
      }
    }

    // Add new pages
    for (var i = 0; i < newRoutes.length; i++) {
      if (!_pages.any((e) => e.matchKey.hasName(newRoutes[i].name))) {
        final r = newRoutes[i];
        _pages.add(DeclarativePageCreator(r.name, QKey(r.name), r.pageType)
            .createWithChild(r.builder()));
      }
    }
    routes = newRoutes;
  }
}
