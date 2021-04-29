import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/page.dart';
import '../helpers/qbutton.dart';
import '../routes.dart';

class NestedRoutePage extends StatelessWidget {
  final QRouter router;
  NestedRoutePage(this.router);
  @override
  Widget build(BuildContext context) {
    return PageContainer(Column(
      children: [
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          QButton("child", () => QR.toName(AppRoutes.nestedChild)),
          QButton("child 1", () => QR.toName(AppRoutes.nestedChild1)),
          QButton("child 2", () => QR.toName(AppRoutes.nestedChild2)),
          QButton("child 3", () => QR.toName(AppRoutes.nestedChild3)),
        ])),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Check the defrrint between showDialog() and QDialog'),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text('Hi'),
                              ));
                    },
                    child: Text('Normal show dialog function')),
                TextButton(
                    onPressed: () {
                      router.navigator.show(QDialog(
                          widget: (onPop) => AlertDialog(title: Text('Hi'))));
                    },
                    child: Text('Show QDialog')),
              ],
            ),
          ),
        ),
        Expanded(child: router),
      ],
    ));
  }
}

class NestedChild extends StatelessWidget {
  final String text;
  NestedChild(this.text);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text('Hi nesated $text', style: TextStyle(fontSize: 18)),
        TextButton(onPressed: QR.back, child: Text('Back')),
      ],
    ));
  }
}
