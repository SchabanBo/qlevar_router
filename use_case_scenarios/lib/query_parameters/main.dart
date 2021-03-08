import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() => runApp(MyApp());

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
        QRoute(path: '/', builder: () => HomePage()),
        QRoute(path: '/products', builder: () => ProductPage()),
      ];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          QR.to('/products?id=${Random().nextInt(100)}&text=hi');
        },
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: ListTile(
            title: Text('Click me'.toString()),
          ),
        ),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = QR.params['id'].toString();
    final text = QR.params['text'].toString();
    return Scaffold(
      body: Center(
        child: Text('text = $text \n\n id = $id'),
      ),
    );
  }
}
