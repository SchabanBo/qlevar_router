import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';

void main() {
  testWidgets('Issue 139', (tester) async {
    QR.reset();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('go to test'), findsOneWidget);
    expectedPath('/');
    await tester.tap(find.text('go to test'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    expectedPath('/test');
    await tester.tap(find.byTooltip("Back"));
    await tester.pumpAndSettle();
    expect(find.text('go to test'), findsOneWidget);
    expect(find.byIcon(Icons.ac_unit), findsNothing);
    expectedPath('/');
    await tester.tap(find.text('go to test'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    expectedPath('/test');
    await tester.tap(find.byTooltip("Back"));
    await tester.pumpAndSettle();
    expect(find.text('go to test'), findsOneWidget);
    expect(find.byIcon(Icons.ac_unit), findsNothing);
    expectedPath('/');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<QRoute> router = [
      QRoute(
        path: '/',
        builder: () {
          return const HomePage();
        },
      ),
    ];
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(router, withWebBar: true),
    );
  }
}

const navigatorName = 'bottom sheet';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: const Text("go to test"),
                onPressed: () async {
                  QR.navigator.addRoutes([
                    QRoute(
                      path: '/test',
                      name: 'test',
                      builder: () => const PageOne(),
                    ),
                  ]);
                  QR.to('/test');
                },
              ),
              QR.history.debug(),
            ],
          ),
        ));
  }
}

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  void dispose() {
    QR.navigator.removeRoutes(['test']);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page One"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ac_unit),
          ],
        ),
      ),
    );
  }
}
