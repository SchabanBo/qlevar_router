import 'package:example/helpers/database.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../helpers/qbutton.dart';

class ParentPage extends StatefulWidget {
  @override
  _ParentPageState createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent'),
      ),
      body: Wrap(
        children: [
          QButton("child", () => QR.to("/parent/child")),
          QButton("child 1", () => QR.to("/parent/child-1")),
          QButton("child 2", () => QR.to("/parent/child-2")),
          QButton("child 3", () => QR.to("/parent/child-3")),
          Card(
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
          )
        ],
      ),
    );
  }
}
