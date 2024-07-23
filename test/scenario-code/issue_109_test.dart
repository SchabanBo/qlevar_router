import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  testWidgets('Issue 109', (widgetTester) async {
    await widgetTester.pumpWidget(const App());
    await widgetTester.pumpAndSettle();
    expect(find.text('Home Page'), findsOneWidget);
  });
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(
        AppRoutes().routes,
        initPath: '/dash',
      ),
    );
  }
}

class AppRoutes {
  static const String homePage = 'Home Page';

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
      ],
    ),
  ];
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home'));
  }
}
