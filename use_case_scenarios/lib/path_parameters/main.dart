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
            ),
            Wrap(
              children: List.generate(10, (index) => index)
                  .map((e) => TextButton(
                        //Navigate to a specific id
                        onPressed: () => QR.to("/$e"),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: 200,
                            height: height * 0.2,
                            color: Colors.grey.shade400,
                            child: Center(
                              child: Text(
                                'id =$e',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
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

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(QR.params['id']);
    final id = QR.params['id']?.asInt ?? 'No id';
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Center(
        child: Text(
          'id = $id',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
