import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = QPages(routes: [
      QRoute(path: '/', page: HomeScreen()),
      QRoute(
          path: '/user',
          page: UserScreen(
            userId: '2',
          )),
      QRoute(
          path: '/pref',
          page: UserPreferencesScreen(
            userId: '1',
          )),
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
            OutlinedButton(
              child: Text('Go to User'),
              onPressed: () {
                QRouter.of(context).pushNamed('/user');
              },
            ),
            OutlinedButton(
              child: Text('Push using the Navigator'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            )
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
            OutlinedButton(
              child: Text('Preferences'),
              onPressed: () {
                QRouter.of(context).pushNamed('/pref');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserPreferencesScreen extends StatelessWidget {
  final String userId;

  UserPreferencesScreen({
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(
              'User Preferences',
              style: Theme.of(context).textTheme.headline3,
            ),
            Text('ID $userId'),
          ],
        ),
      ),
    );
  }
}
