import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../qlevar_router.dart';
import '../../controllers/qrouter_controller.dart';

// coverage:ignore-file
class BrowserAddressBar extends StatefulWidget {
  static bool get isNeeded => (kReleaseMode || kIsWeb) ? false : true;

  final Function(String) setNewRoute;
  final QRouterController _controller;
  const BrowserAddressBar(this.setNewRoute, this._controller, {Key? key})
      : super(key: key);
  @override
  State createState() => _BrowserAddressBarState();
}

class _BrowserAddressBarState extends State<BrowserAddressBar> {
  final List<String> _paths = [];
  final controller = TextEditingController(text: QR.currentPath);
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
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                final path = QR.currentPath;
                if (await QR.back() == PopResult.Popped) {
                  _paths.add(path);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _paths.isEmpty
                  ? null
                  : () {
                      final path = _paths.last;
                      _paths.removeLast();
                      widget.setNewRoute(path);
                    },
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 18, top: -3, right: 15)),
                  onFieldSubmitted: (s) {
                    widget.setNewRoute(s);
                    _paths.clear();
                  },
                ),
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}
