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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final controller = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.3,
              color: Colors.grey.shade500,
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: width * 0.6,
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Search',
                        ),
                      )),
                  SizedBox(width: 25),
                  TextButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          QR.to('/products?q=${controller.text}');
                          controller.clear();
                        }
                      },
                      child: Text(
                        'Search',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
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

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final text = QR.params['q'].toString();
    return Scaffold(
      body: Center(
        child: Text('q = $text'),
      ),
    );
  }
}
