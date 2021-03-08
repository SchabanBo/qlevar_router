import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/page.dart';
import '../helpers/qbutton.dart';

class NestedRoutePage extends StatelessWidget {
  final QRouter router;
  NestedRoutePage(this.router);
  @override
  Widget build(BuildContext context) {
    return PageContainer(Column(
      children: [
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          QButton("child", () => QR.to("/nested/child")),
          QButton("child 1", () => QR.to("/nested/child-1")),
          QButton("child 2", () => QR.to("/nested/child-2")),
          QButton("child 3", () => QR.to("/nested/child-3")),
        ])),
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
