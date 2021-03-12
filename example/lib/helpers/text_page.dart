import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'date_time.dart';
import 'page.dart';

class TextPage extends StatelessWidget {
  final String text;
  TextPage(this.text);
  @override
  Widget build(BuildContext context) {
    return PageContainer(Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(child: Text(text)),
        Center(child: Text(now)),
        Center(child: TextButton(onPressed: QR.back, child: Text('Back'))),
      ],
    ));
  }
}
