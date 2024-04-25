import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  testWidgets('RouteMock path', (tester) async {
    // Set up env
    QR.reset();
    QR.settings.mockRoute = _RouteMock();

    await tester.pumpWidget(const MaterialApp(home: _TestWidget()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.done));
    await tester.pumpAndSettle();
    expect(QR.currentPath, '/home');
  });

  testWidgets('RouteMock name', (tester) async {
    // Set up env
    QR.reset();
    QR.settings.mockRoute = _RouteNameMock();

    await tester.pumpWidget(const MaterialApp(home: _TestNameWidget()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.done));
    await tester.pumpAndSettle();
    expect(QR.currentPath, '/home');
  });
}

class _RouteMock extends RouteMock {
  @override
  String? mockName(String name) {
    return null;
  }

  @override
  QRoute? mockPath(String path) {
    if (path == '/home') {
      return QRoute(path: '/home', builder: () => const SizedBox.shrink());
    }
    return null;
  }
}

class _TestWidget extends StatelessWidget {
  const _TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IconButton(
        onPressed: () {
          QR.to('/home');
        },
        icon: const Icon(Icons.done),
      ),
    );
  }
}

class _RouteNameMock extends RouteMock {
  @override
  String? mockName(String name) {
    if (name == 'home') return '/home';
    return null;
  }

  @override
  QRoute? mockPath(String path) {
    if (path == '/home') {
      return QRoute(path: '/home', builder: () => const SizedBox.shrink());
    }
    return null;
  }
}

class _TestNameWidget extends StatelessWidget {
  const _TestNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IconButton(
        onPressed: () {
          QR.toName('home');
        },
        icon: const Icon(Icons.done),
      ),
    );
  }
}
