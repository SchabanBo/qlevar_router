import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../helpers/qbutton.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Wrap(
        children: [
          QButton("Parent Page", () => QR.to("/parent")),
          QButton("Parent Page -> Child", () => QR.to("/parent/child")),
          QButton("params /:id", () => QR.to("/${Random().nextInt(1000)}")),
          QButton(
              "Query Params",
              () => QR.to(
                  "/params?test=${Random().nextInt(1000)}&go=${Random().nextInt(1000)}")),
        ],
      ),
    );
  }
}
