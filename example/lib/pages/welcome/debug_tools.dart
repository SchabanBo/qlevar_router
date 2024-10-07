import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class DebugTools extends StatelessWidget {
  const DebugTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        QR.getActiveTree(),
        const SizedBox(width: 15),
        QR.history.debug(),
      ],
    );
  }
}
