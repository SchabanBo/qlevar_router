import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';
import '../test_widgets/test_widgets.dart';

List<String> _tabs = [
  "Home Page",
  "Store Page",
  "Settings Page",
];

int indexOf(String name) => _tabs.indexWhere((e) => e == name);
void main() {
  final routes = [
    QRoute.withChild(
      path: '/home',
      builderChild: (c) => NavRailExample(c),
      children: [
        QRoute(
          name: _tabs[0],
          pageType: const QSlidePage(),
          path: '/',
          builder: () => const Tab('Home'),
        ),
        QRoute(
          name: _tabs[1],
          pageType: const QSlidePage(),
          path: '/store',
          builder: () => const Tab('Store'),
        ),
        QRoute(
          name: _tabs[2],
          pageType: const QSlidePage(),
          path: '/settings',
          builder: () => const Tab('Settings'),
        ),
      ],
    ),
  ];
  testWidgets('Test issue 90', (widgetTester) async {
    QR.reset();
    isActionBringToTop = false;
    await widgetTester.pumpWidget(AppWrapper(routes, initPath: '/home'));
    await widgetTester.pumpAndSettle();
    expectedPath('/home');
    final currentNestedRouter = QR.navigatorOf('/home');
    await widgetTester.tap(find.byIcon(Icons.store));
    await widgetTester.pumpAndSettle();
    expectedPath('/home/store');
    await widgetTester.tap(find.byIcon(Icons.settings));
    await widgetTester.pumpAndSettle();
    expectedPath('/home/settings');
    await widgetTester.tap(find.byIcon(Icons.home));
    await widgetTester.pumpAndSettle();
    expectedPath('/home');
    final newNestedRouter = QR.navigatorOf('/home');
    expect(currentNestedRouter.hashCode, newNestedRouter.hashCode);
  });

  testWidgets('Test path updates if action is bring to top',
      (widgetTester) async {
    QR.reset();
    isActionBringToTop = true;
    await widgetTester.pumpWidget(AppWrapper(routes, initPath: '/home'));
    await widgetTester.pumpAndSettle();
    expectedPath('/home');
    await widgetTester.tap(find.byIcon(Icons.store));
    await widgetTester.pumpAndSettle();
    expectedPath('/home/store');
    await widgetTester.tap(find.byIcon(Icons.settings));
    await widgetTester.pumpAndSettle();
    expectedPath('/home/settings');
    await widgetTester.tap(find.byIcon(Icons.home));
    await widgetTester.pumpAndSettle();
    expectedPath('/home');
  });
}

var isActionBringToTop = false;

class NavRailExample extends StatefulWidget {
  const NavRailExample(this.router, {Key? key}) : super(key: key);

  final QRouter router;

  @override
  State<NavRailExample> createState() => _NavRailExampleState();
}

class _NavRailExampleState extends RouterState<NavRailExample> {
  @override
  QRouter get router => widget.router;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: indexOf(widget.router.routeName),
            onDestinationSelected: (v) => QR.toName(
              _tabs[v],
              pageAlreadyExistAction: isActionBringToTop
                  ? PageAlreadyExistAction.BringToTop
                  : PageAlreadyExistAction.Remove,
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.store),
                label: Text('Store'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.router),
        ],
      ),
    );
  }
}

class Tab extends StatelessWidget {
  const Tab(this.name, {Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(name, style: const TextStyle(fontSize: 20)),
      );
}
