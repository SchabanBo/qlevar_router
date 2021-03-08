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
        QRoute(path: '/:id', builder: () => ProductPage()),
      ];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: List.generate(10, (index) => index)
            .map(
              (e) => GestureDetector(
                onTap: () {
                  QR.to("/$e");
                },
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ListTile(
                    title: Text(e.toString()),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = QR.params['id']?.asInt ?? 'No id';
    return Scaffold(
      body: Center(
        child: Text(id.toString()),
      ),
    );
  }
}
