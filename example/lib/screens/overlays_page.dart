import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/page.dart';
import '../helpers/qbutton.dart';

class OverlaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: content,
            ))));
  }

  List<Widget> get content => [
        QButton(
            "Show Dialog",
            () => QR.show(QDialog(
                widget: (pop) => AlertDialog(title: Text('Hi Dialog'))))),
        QButton("Show Text Dialog",
            () => QDialog.text(text: Text('Simple Text')).show()),
      ];
}
