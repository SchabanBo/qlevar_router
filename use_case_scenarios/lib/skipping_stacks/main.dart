import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: QRouteInformationParser(),
        routerDelegate:
            QRouterDelegate(AppRoutes().routes(), initPath: '/home'),
      );
}

const products = [
  'Shoes',
  'PC',
  'Water',
  'Printer',
  'Phone',
  'Headset',
  'T-Shirt',
  'Bed'
];

class AppRoutes {
  List<QRoute> routes() => <QRoute>[
        QRoute(path: '/home', builder: () => HomePage()),
        QRoute(path: '/search', builder: () => SearchPage()),
        QRoute(path: '/products', builder: () => ProductsPage(), children: [
          QRoute(path: '/:product', builder: () => ProductDetails()),
        ]),
      ];
}

class HomePage extends StatelessWidget {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Skipping Stacks', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey.shade100,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('''
Any search value will give the same result, not the best search engine, I know :)'''),
                Container(
                  height: size.height * 0.3,
                  color: Colors.grey.shade400,
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: size.width * 0.7,
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Search',
                            ),
                          )),
                      SizedBox(width: 25),
                      ElevatedButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              QR.to('/search?q=${controller.text}');
                            }
                          },
                          child: Text('Search'))
                    ],
                  ),
                ),
                Products(),
              ],
            ),
          ),
        ));
  }
}

class SearchPage extends StatelessWidget {
  final searchFor = QR.params['q'] ?? 'Empty';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Result for $searchFor',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey.shade100,
        ),
        body: Products());
  }
}

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Products Page', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey.shade100,
        ),
        body: Products());
  }
}

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: products
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () => QR.to('/products/$e'),
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 150,
                            color: Colors.grey.shade400,
                          ),
                          Text(e, style: TextStyle(fontSize: 18)),
                        ],
                      )),
                ))
            .toList());
  }
}

class ProductDetails extends StatelessWidget {
  final product = QR.params['product']!.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product Details', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.grey.shade100,
        ),
        body: Padding(
          padding: EdgeInsets.all(50),
          child: Row(
            children: [
              getPlaceHolder(flex: 4),
              Flexible(
                  flex: 5,
                  child: Column(
                    children: [
                      Text(product, style: TextStyle(fontSize: 26)),
                      linesPlaceHolder,
                    ],
                  ))
            ],
          ),
        ));
  }

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
          onTap: () => QR.to('/games/${Random().nextInt(1000)}'),
          child: Container(color: Colors.grey.shade400)));
}
