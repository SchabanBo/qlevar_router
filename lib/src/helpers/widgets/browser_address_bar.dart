import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../qlevar_router.dart';
import '../../controllers/qrouter_controller.dart';

class BrowserAddressBar extends StatefulWidget {
  static bool get isNeeded => (kReleaseMode || kIsWeb) ? false : true;

  final Function(String) setNewRoute;
  final QRouterController _controller;
  BrowserAddressBar(this.setNewRoute, this._controller);
  @override
  _BrowserAddressBarState createState() => _BrowserAddressBarState();
}

class _BrowserAddressBarState extends State<BrowserAddressBar> {
  final List<String> _paths = [];
  final controller = TextEditingController();
  String path = '/';

  @override
  void initState() {
    super.initState();
    widget._controller.addListener(() {
      setState(() {
        controller.text = QR.currentPath;
        if (_paths.isNotEmpty && QR.currentPath != _paths.last) {
          _paths.clear();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        home: Material(
            child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                final path = QR.currentPath;
                if (QR.back()) {
                  _paths.add(path);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _paths.isEmpty
                  ? null
                  : () {
                      final path = _paths.last;
                      _paths.removeLast();
                      widget.setNewRoute(path);
                    },
            ),
            SizedBox(width: 25),
            Expanded(
                child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 18, top: -3, right: 15)),
                      onFieldSubmitted: (s) {
                        widget.setNewRoute(s);
                        _paths.clear();
                      },
                    ))),
            SizedBox(width: 50),
          ],
        )));
  }
}
