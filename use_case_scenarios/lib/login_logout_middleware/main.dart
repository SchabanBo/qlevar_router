import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() => runApp(MyApp());

class AuthService {
  // static bool isAuthed = Random().nextBool();
  static bool isAuthed = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.amber,
        ),
        routeInformationParser: QRouteInformationParser(),
        routerDelegate: QRouterDelegate(AppRoutes().routes()),
      );
}

class AppRoutes {
  List<QRoute> routes() => <QRoute>[
        QRoute(
          path: '/',
          builder: () => HomePage(),
          middleware: [
            QMiddlewareBuilder(
              redirectGuardFunc: () {
                return Future.microtask(
                  () {
                    final isAuthed = AuthService.isAuthed;
                    print('isAuthed = $isAuthed');
                    return isAuthed ? null : 'login';
                  },
                );
              },
            )
          ],
        ),
        QRoute(path: '/login', builder: () => LoginPage()),
      ];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width,
              height: height * 0.4,
              color: Colors.grey.shade300,
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    AuthService.isAuthed = false;
                    QR.to('/login');
                  },
                  child: Text('Log out'),
                ),
              ),
            ),
            Wrap(
              children: List.generate(10, (index) => index)
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 200,
                          height: height * 0.2,
                          color: Colors.grey.shade400,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 50),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 10),
            _loginBlockHolder(width, height),
            const SizedBox(height: 10),
            _loginBlockHolder(width, height),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                AuthService.isAuthed = true;
                QR.to('/');
              },
              child: Text(
                'Log in',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _loginBlockHolder(double width, double height) {
    return Container(
      width: width * 0.5,
      height: height * 0.05,
      color: Colors.grey.shade100,
    );
  }
}
