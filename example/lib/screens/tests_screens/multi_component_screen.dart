import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/date_time.dart';
import '../../routes.dart';

class TestMultiComponent extends StatelessWidget {
  final QRouter router;
  TestMultiComponent(this.router);

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'It Works',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          Text('$now', style: TextStyle(fontSize: 22, color: Colors.white)),
          SizedBox(height: 18),
          Text(
            '''
The request is:
  onPressed: () {
    QR.toName(AppRoutes.testMultiComponent,
        params: {'name': 'Max', 'number': 55});
},
             ''',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            'The Name is: ${QR.params['name'].toString()}',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          Text(
            'The Number is: ${QR.params['number'].toString()}',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          SizedBox(height: 18),
          RaisedButton(
              onPressed: () {
                final param = QR.params['childNumber'] == null
                    ? 0
                    : (int.parse(QR.params['childNumber'].toString()) + 1);

                QR.toName(AppRoutes.testMultiComponentChild,
                    params: {'childNumber': param});
              },
              child: Text('Update Child')),
          SizedBox(height: 18),
          SizedBox(height: 100, width: 250, child: router)
        ],
      ));
}

class TestMultiComponentChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Center(
        child: Text(
          'The childNumber is: ${QR.params['childNumber'].toString()}',
          style: TextStyle(fontSize: 22, color: Colors.green),
        ),
      ),
    );
  }
}
