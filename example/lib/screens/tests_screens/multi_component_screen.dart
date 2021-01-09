import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class TestMultiComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'It Works',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
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
        ],
      ));
}
