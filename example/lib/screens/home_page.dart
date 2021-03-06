import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../helpers/qbutton.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Wrap(
        children: [
          QButton("/parent", () => QR.to("/parent")),
          QButton("/parent/child", () => QR.to("/parent/child")),
          QButton("/:id", () => QR.to("/${Random().nextInt(1000)}")),
          QButton(
              "/params",
              () => QR.to(
                  "/params?test=${Random().nextInt(1000)}&go=${Random().nextInt(1000)}")),
        ],
      ),
    );
  }
}
