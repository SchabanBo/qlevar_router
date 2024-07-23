import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  testWidgets('Issue 112', (tester) async {
    QR.reset();
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(
        AppRoutes().routes,
        initPath: '/dash',
        alwaysAddInitPath: true,
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    await tester.tap(find.text('To second'));
    await tester.pumpAndSettle();
    expect(find.text('Second Page'), findsOneWidget);

    /// simulate browser restart
    QR.reset();
    final delegate = QRouterDelegate(
      AppRoutes().routes,
      initPath: '/dash',
      alwaysAddInitPath: true,
    );
    await tester.pumpWidget(MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: delegate,
    ));
    await delegate.setInitialRoutePath('/dash/second');
    await tester.pumpAndSettle();
    expect(find.text('Second Page'), findsOneWidget);

    /// simulate browser back
    await delegate.setNewRoutePath('/dash');
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    QR.settings.enableDebugLog = true;
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(
        AppRoutes().routes,
        initPath: '/dash',
        alwaysAddInitPath: true,
      ),
    );
  }
}

class AppRoutes {
  static const String homePage = 'Home Page';
  static const String secondPage = 'Second Page';

  final routes = [
    QRoute.withChild(
      path: '/dash',
      builderChild: (child) {
        final routeName = child.routeName;
        return Scaffold(
          appBar: AppBar(
            title: Text(routeName),
          ),
          body: child,
        );
      },
      children: [
        QRoute(
          name: homePage,
          path: '/',
          builder: () => const HomePage(),
        ),
        QRoute(
          name: secondPage,
          path: '/second',
          builder: () => const SecondPage(),
        ),
      ],
    ),
  ];
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: Text('Home')),
        ElevatedButton(
          onPressed: () {
            QR.toName(AppRoutes.secondPage);
          },
          child: const Text('To second'),
        ),
      ],
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: Text('Second Page')),
        ElevatedButton(
          onPressed: () {
            QR.toName(AppRoutes.homePage);
          },
          child: const Text('To Home'),
        ),
      ],
    );
  }
}
