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
  // pageAlreadyExistAction = PageAlreadyExistAction.BringToTop;
  // runApp(AppWrapper(routes, initPath: '/home'));
  // return;
  testWidgets('Test issue 90', (widgetTester) async {
    QR.reset();
    pageAlreadyExistAction = PageAlreadyExistAction.Remove;
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

  testWidgets(
      'Test path updates if action is bring to top with ignore children',
      (widgetTester) async {
    QR.reset();
    pageAlreadyExistAction = PageAlreadyExistAction.IgnoreChildrenAndBringToTop;
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

  testWidgets(
      'Test path updates if action is bring to top without ignoring children',
      (widgetTester) async {
    // in this case BringToTop should ignore children, because the route is /
    // which mean the children of this route are the siblings
    QR.reset();
    pageAlreadyExistAction = PageAlreadyExistAction.BringToTop;
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

var pageAlreadyExistAction = PageAlreadyExistAction.Remove;

class NavRailExample extends StatefulWidget {
  const NavRailExample(this.router, {super.key});

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
              pageAlreadyExistAction: pageAlreadyExistAction,
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
  const Tab(this.name, {super.key});

  final String name;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(name, style: const TextStyle(fontSize: 20)),
      );
}
