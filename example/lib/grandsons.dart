import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class Grandson1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Grandson 1',
          style: Theme.of(context).textTheme.headline3,
        ),
        TextButton(
          child: Text('To Grandson 2'),
          onPressed: () {
            QRouter.of(context).pushNamed('/Grandson2');
          },
        ),
      ],
    );
  }
}

class Grandson2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Grandson 2',
          style: Theme.of(context).textTheme.headline3,
        ),
        TextButton(
          child: Text('To Grandson 3'),
          onPressed: () {
            QRouter.of(context).pushNamed('/Grandson3');
          },
        ),
      ],
    );
  }
}

class Grandson3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Grandson 3',
          style: Theme.of(context).textTheme.headline3,
        ),
        TextButton(
          child: Text('To Grandson 1'),
          onPressed: () {
            QRouter.of(context).replaceAllNamed(['/']);
          },
        ),
      ],
    );
  }
}