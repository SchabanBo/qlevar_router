import 'package:example/childrens.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = QPages(routes: [
      QRoute(path: '/', page: HomeScreen()),
      QRoute(
          path: '/user',
          page: UserScreen(
            userId: '2',
          )),
      QRoute(path: '/settings', page: SettingsScreen()),
    ]);
    return QRouter(
        child: MaterialApp.router(
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.informationParser,
        ),
        pages: router);
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Home Page',
              style: Theme.of(context).textTheme.headline3,
            ),
            TextButton(
              child: Text('To User'),
              onPressed: () {
                QRouter.of(context).pushNamed('/user');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  final String userId;

  UserScreen({
    this.userId,
  });

  final router = QPages(routes: [
    QRoute(path: '/', page: Child1()),
    QRoute(path: '/child2', page: Child2()),
    QRoute(path: '/child3', page: Child3()),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              'User',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text('ID: $userId'),
            TextButton(
              child: Text('To Settings'),
              onPressed: () {
                QRouter.of(context).pushNamed('/settings');
              },
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.amber,
            ),
            Expanded(
              child: QRouter(
                pages: router,
                child: Router(
                  routerDelegate: router.routerDelegate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headline3,
            ),
            TextButton(
              child: Text('To Home'),
              onPressed: () {
                QRouter.of(context).replaceAllNamed(['/']);
              },
            ),
          ],
        ),
      ),
    );
  }
}
