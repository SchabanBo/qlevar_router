import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';

void main() {
  testWidgets('issue 101', (WidgetTester widgetTester) async {
    final routes = [
      QRoute(path: '/login', builder: () => const LoginScreen()),
      QRoute.withChild(
          path: '/dashboard',
          builderChild: (c) => Dashboard(c),
          initRoute: '/info',
          children: [
            QRoute(
                path: '/info',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Info', Colors.grey.shade900)),
            QRoute(
                path: '/orders',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Orders', Colors.grey.shade700)),
            QRoute(
                path: '/items',
                pageType: const QFadePage(),
                builder: () => DashboardChild('Items', Colors.grey.shade500)),
          ]),
    ];
    final delegate = QRouterDelegate(routes, initPath: '/login');
    await widgetTester.pumpWidget(MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: delegate,
    ));
    await widgetTester.pumpAndSettle();
    expectedPath('/login');
    await widgetTester.tap(find.text('Login'));
    await widgetTester.pumpAndSettle();
    expectedPath('/dashboard/info');
    QR.to('/dashboard/orders');
    await widgetTester.pumpAndSettle();
    expectedPath('/dashboard/orders');
    await widgetTester.tap(find.text('Show bottom sheet main'));
    await widgetTester.pumpAndSettle();
    expect(find.text('This is the modal bottom sheet'), findsOneWidget);
    // simulate back button
    await delegate.popRoute();
    await widgetTester.pumpAndSettle();
    // should only pop the bottom sheet
    expectedPath('/dashboard/orders');
    await widgetTester.tap(find.text('Show dialog main'));
    await widgetTester.pumpAndSettle();
    expect(find.text('This is dialog'), findsOneWidget);
    // simulate back button
    await delegate.popRoute();
    await widgetTester.pumpAndSettle();
    // should only pop the dialog
    expectedPath('/dashboard/orders');

    // now try to show bottom sheet from dashboard navigator
    await widgetTester.tap(find.text('Show bottom sheet'));
    await widgetTester.pumpAndSettle();
    expect(find.text('This is the modal bottom sheet'), findsOneWidget);
    // simulate back button
    await delegate.popRoute();
    await widgetTester.pumpAndSettle();
    // should only pop the bottom sheet
    expectedPath('/dashboard/orders');
    await widgetTester.tap(find.text('Show dialog'));
    await widgetTester.pumpAndSettle();
    expect(find.text('This is dialog'), findsOneWidget);
    // simulate back button
    await delegate.popRoute();
    await widgetTester.pumpAndSettle();
    // should only pop the dialog
    expectedPath('/dashboard/orders');
  });
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Login page'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () => QR.to('/dashboard'),
              child: const Text('Login'),
            ),
          ],
        ),
      );
}

class Dashboard extends StatelessWidget {
  final QRouter router;
  const Dashboard(this.router, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
        ),
        body: Row(
          children: [Expanded(child: router)],
        ),
      );
}

class DashboardChild extends StatelessWidget {
  final String name;
  final Color color;
  const DashboardChild(this.name, this.color, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _showSheet(context, true);
          },
          child: const Text('Show bottom sheet main'),
        ),
        ElevatedButton(
          onPressed: () {
            _showDialog(context, true);
          },
          child: const Text('Show dialog main'),
        ),
        ElevatedButton(
          onPressed: () {
            _showSheet(context, false);
          },
          child: const Text('Show bottom sheet'),
        ),
        ElevatedButton(
          onPressed: () {
            _showDialog(context, false);
          },
          child: const Text('Show dialog'),
        ),
        Container(
          color: color,
          child: Center(
            child: Text(name, style: const TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _showSheet(BuildContext context, bool useRootNavigator) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (c) => Container(
        height: 200,
        color: Colors.amber,
        child: Column(
          children: [
            const Center(
              child: Text('This is the modal bottom sheet'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(c);
              },
              child: const Text('Close'),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, bool useRootNavigator) {
    return showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierLabel: 'test',
      builder: (c) => AlertDialog(
        content: Container(
          height: 200,
          color: Colors.amber,
          child: Column(
            children: [
              const Center(
                child: Text('This is dialog'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(c);
                },
                child: const Text('Close'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
