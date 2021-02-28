import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/date_time.dart';
import 'test_routes.dart';

class TestMultiComponentParent extends StatelessWidget {
  final QRouteChild routeChild;
  TestMultiComponentParent(this.routeChild);
  final number = TextEditingController(text: '55');
  final name = TextEditingController(text: 'max');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$now', style: TextStyle(fontSize: 22)),
                  Text('Send a name and number to the child',
                      style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 10),
                  Text('Name', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 200, child: TextField(controller: name)),
                  const SizedBox(height: 10),
                  Text('Number', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 200, child: TextField(controller: number)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        if (name.text.isEmpty && number.text.isEmpty) {
                          return;
                        }
                        QR.toName(TestRoutes.testMultiComponent,
                            params: {'name': name.text, 'number': number.text});
                      },
                      child: Text('Send Data')),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: routeChild.childRouter)
      ],
    );
  }
}

class TestMultiComponent extends StatelessWidget {
  final QRouteChild routeChild;
  TestMultiComponent(this.routeChild);

  @override
  Widget build(BuildContext context) => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$now', style: TextStyle(fontSize: 22, color: Colors.white)),
          Text(
            'The Name is: ${QR.params['name'].toString()}',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          Text(
            'The Number is: ${QR.params['number'].toString()}',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
              onPressed: () {
                final param = QR.params['childNumber'] == null
                    ? 0
                    : (QR.params['childNumber'].asInt + 1);

                QR.toName(TestRoutes.testMultiComponentChild,
                    params: {'childNumber': param});
              },
              child: Text('Update Child')),
          const SizedBox(height: 18),
          SizedBox(height: 100, width: 250, child: routeChild.childRouter)
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
