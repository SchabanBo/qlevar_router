import 'package:flutter/material.dart';
import 'package:example/grandsons.dart';
import 'package:qlevar_router/qlevar_router.dart';

class Child1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Child 1 $now',
          style: Theme.of(context).textTheme.headline3,
        ),
        TextButton(
          child: Text('To child 2'),
          onPressed: () {
            QRouter.of(context).pushNamed('/child2');
          },
        ),
      ],
    );
  }
}

class Child2 extends StatelessWidget {
  final router = QPages(routes: [
    QRoute(path: '/', page: Grandson1()),
    QRoute(path: '/Grandson2', page: Grandson2()),
    QRoute(path: '/Grandson3', page: Grandson3()),
  ]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Child 2 $now',
          style: Theme.of(context).textTheme.headline3,
        ),
        TextButton(
          child: Text('To child 3'),
          onPressed: () {
            QRouter.of(context).pushNamed('/child3');
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
              routeInformationParser: router.informationParser,
              routeInformationProvider:
                  QRouteInformationProvider(initialRoute: '/'),
            ),
          ),
        )
      ],
    );
  }
}

class Child3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Child 3 $now',
          style: Theme.of(context).textTheme.headline3,
        ),
        TextButton(
          child: Text('To child 1'),
          onPressed: () {
            QRouter.of(context).replaceAllNamed(['/']);
          },
        ),
      ],
    );
  }
}
