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

  final List<QDRoute>? routes = [];

  final _pages = <QPageInternal>[];

  void update() {
    setState(() {});
  }

  /// Did the pop proceed
  bool pop() {
    final pop = routes!.last.onPop!();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
    return pop ?? true;
  }

  @override
  Widget build(BuildContext context) {
    updatePages();
    assert(_pages.isNotEmpty);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        pop();
      },
      child: Navigator(
        key: navKey,
        pages: List.unmodifiable(_pages),
        onDidRemovePage: (page) {},
      ),
    );
  }

  void updatePages() {
    final buildRoutes = widget.builder();
    assert(
        buildRoutes.any((e) => e.when()),
        // ignore: lines_longer_than_80_chars
        'No route has returned true as [when] result from QDeclarative.builder');
    final newRoute = widget.builder().firstWhere((e) => e.when());
    final index = _pages.indexWhere((e) => e.matchKey.hasName(newRoute.name));

    if (index == -1) {
      final r = newRoute;
      _pages.add(DeclarativePageCreator(r.name, QKey(r.name), r.pageType)
          .createWithChild(r.builder()));
    } else {
      final length = _pages.length;
      for (var i = index + 1; i < length; i++) {
        _pages.removeLast();
      }
    }

    routes!.add(newRoute);
  }
}
