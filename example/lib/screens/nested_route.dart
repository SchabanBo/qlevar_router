import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../helpers/qbutton.dart';

class NestedRoutePage extends StatelessWidget {
  final QRouter router;
  NestedRoutePage(this.router);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nested Routing'),
        ),
        body: Column(
          children: [
            Expanded(
                child: Wrap(children: [
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
