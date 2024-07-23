import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers.dart';

void main() {
  testWidgets('Isolated Router', (widgetTester) async {
    QR.reset();
    await widgetTester.pumpWidget(const _MyApp());
    await widgetTester.pumpAndSettle();
    expect(find.text('Page One'), findsNothing);
    expect(find.text('Page Tow'), findsNothing);
    expect(find.text('Open Login Bottom Sheet'), findsOneWidget);
    expectedPath('/');
    await widgetTester.tap(find.text('Open Login Bottom Sheet'));
    await widgetTester.pumpAndSettle();
    expect(find.text('Page One'), findsOneWidget);
    expect(find.text('Page Tow'), findsNothing);
    expectedPath('/bottomSheet/1');
    await widgetTester.tap(find.text('Go to page 2'));
    await widgetTester.pumpAndSettle();
    expect(find.text('Page One'), findsNothing);
    expect(find.text('Page Tow'), findsOneWidget);
    expectedPath('/bottomSheet/2');
    await widgetTester.tap(find.byTooltip("Back"));
    await widgetTester.pumpAndSettle();
    expect(find.text('Page One'), findsOneWidget);
    expect(find.text('Page Tow'), findsNothing);
    expectedPath('/bottomSheet/1');
    await widgetTester.tap(find.text('Back'));
    await widgetTester.pumpAndSettle();
    expect(find.text('Page One'), findsNothing);
    expect(find.text('Page Tow'), findsNothing);
    expectedPath('/');
  });
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    final List<QRoute> router = [
      QRoute(
        path: '/',
        builder: () {
          return const _HomePage();
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

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text("Open Login Bottom Sheet"),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: TemporaryQRouter(
                        name: navigatorName,
                        path: '/bottomSheet',
                        initPath: '/1',
                        routes: [
                          QRoute(
                            path: '/1',
                            builder: () {
                              return const _PageOne();
                            },
                          ),
                          QRoute(
                            path: '/2',
                            builder: () {
                              return const _PageTow();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PageOne extends StatelessWidget {
  const _PageOne();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page One")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: const Text("Go to page 2"),
              onPressed: () {
                QR.to('/2');
                //   QR.navigatorOf(navigatorName).push('/2');
              },
            ),
            TextButton(
              child: const Text("Back"),
              onPressed: () {
                QR.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PageTow extends StatelessWidget {
  const _PageTow();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page Tow")),
      body: const Center(child: Icon(Icons.home)),
    );
  }
}
