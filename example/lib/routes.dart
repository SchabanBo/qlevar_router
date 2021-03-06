import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'screens/home_page.dart';

class AppRoutes {
  List<QRoute> routes() => [
        QRoute(path: '/', builder: () => HomePage()),
        QRoute(
            path: '/parent',
            builder: () => TextPage('Hi parent'),
            children: [
              QRoute(path: '/child', builder: () => TextPage('Hi child')),
            ]),
        QRoute(path: '/:id', builder: () => TextPage('Hi ${QR.params['id']}')),
        QRoute(
            path: '/params',
            builder: () => TextPage(
                'Hi test is${QR.params['test']} and go is ${QR.params['go']}')),
      ];
}

class TextPage extends StatelessWidget {
  final String text;
  TextPage(this.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(child: Text(text, style: TextStyle(color: Colors.white))),
            Center(child: TextButton(onPressed: QR.back, child: Text('Back'))),
          ],
        ));
  }
}
