import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
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
        appBar: AppBar(
          title: Text('Dynamic Linking', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey.shade100,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              columnPlaceHolder,
              const SizedBox(width: 10),
              columnPlaceHolder,
              const SizedBox(width: 10),
              columnPlaceHolder,
            ],
          ),
        ));
  }

  Widget get columnPlaceHolder => Flexible(
        child: Column(
          children: [
            const SizedBox(height: 10),
            getPlaceHolder(flex: 2),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Lorem ipsum dolor sit amet',
                    style: TextStyle(fontSize: 22)),
              ),
            ),
            infoPlaceHolder,
            Spacer(),
          ],
        ),
      );

  Widget get infoPlaceHolder => Flexible(
        child: Row(
          children: [
            getPlaceHolder(),
            linesPlaceHolder,
          ],
        ),
      );

  Widget get linesPlaceHolder => Flexible(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getPlaceHolder(),
              Spacer(flex: 2),
              getPlaceHolder(),
              Spacer(flex: 2),
              getPlaceHolder(),
              Spacer(flex: 2),
              getPlaceHolder(),
            ],
          ),
        ),
      );
  Widget getPlaceHolder({int flex = 1}) => Flexible(
      flex: flex,
      child: InkWell(
          onTap: () => QR.to('path'),
          child: Container(color: Colors.grey.shade400)));
}

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(QR.params.asStringMap());
    final id = QR.params['id'].toString();
    final text = QR.params['text'].toString();
    return Scaffold(
      body: Center(
        child: Text('$text $id'),
      ),
    );
  }
}
