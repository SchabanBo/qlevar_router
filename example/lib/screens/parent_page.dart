import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/database.dart';
import '../helpers/page.dart';
import '../helpers/qbutton.dart';

class ParentPage extends StatefulWidget {
  @override
  _ParentPageState createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(Column(
      children: [
        Wrap(
          children: [
            QButton("child", () => QR.to("/parent/child")),
            QButton("child 1", () => QR.to("/parent/child-1")),
            QButton("child 2", () => QR.to("/parent/child-2")),
            QButton("child 3", () => QR.to("/parent/child-3")),
            Card(
              color: Colors.transparent,
              child: Column(
                children: [
                  Text('Test Redirect Gaurd'),
                  Text('If it is allowed to navigate it will go to child 4'),
                  Text('if not it will go to child 2 '),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Can Navigate to Child 4'),
                      Switch(
                          value: Database.canChildNavigate,
                          onChanged: (v) {
                            Database.canChildNavigate = v;
                            setState(() {});
                          })
                    ],
                  ),
                  QButton("child 4", () => QR.to("/parent/child-4")),
                ],
              ),
            ),
            Card(
              color: Colors.transparent,
              child: Column(
                children: [
                  Text('Test Redirect Gaurd To name'),
                  Text('This will redirect to [/nested]'),
                  QButton("redirectGuardName", () => QR.to("/parent/child-5")),
                ],
              ),
            ),
            Card(
              color: Colors.transparent,
              child: Column(
                children: [
                  Text('Replace this page with [/overlays] pages'),
                  QButton(
                      "QR.navigator.replace",
                      // ignore: lines_longer_than_80_chars
                      //() =>QR.navigator.replaceName('Parent', AppRoutes.nested)),
                      () => QR.navigator.replace('/parent', '/overlays')),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
