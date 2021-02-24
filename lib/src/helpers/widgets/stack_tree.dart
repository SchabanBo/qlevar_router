import 'package:flutter/material.dart';
import '../../navigator/page_types.dart';
import '../../navigator/router_controller.dart';

class DebugStackTree extends StatelessWidget {
  final List<RouterController> _controllers;
  DebugStackTree(this._controllers);
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => showDialog(
            context: context,
            builder: (c) => AlertDialog(
                  content: _StackTree(_controllers),
                  title: Text('Stack Tree:', style: TextStyle(fontSize: 16)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(c).pop(),
                        child: Text('Close'))
                  ],
                )),
        child: Text('Debug Stack Tree', style: TextStyle(fontSize: 16)));
  }
}

class _StackTree extends StatelessWidget {
  final List<_ControllerInfo> _controllers = [];
  _StackTree(List<RouterController> controllers) {
    final cons = controllers.map((e) => _ControllerInfo(e)).toList();
    for (var con in cons) {
      if (cons
          .any((element) => element.pages.any((page) => page.key == con.key))) {
        final match = cons.firstWhere(
            (element) => element.pages.any((page) => page.key == con.key));
        match.children.add(con);
        match.pages.removeWhere((element) => element.key == con.key);
      } else {
        _controllers.add(con);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:
            Column(children: _controllers.map((e) => e.getWidget()).toList()));
  }
}

class _ControllerInfo {
  final String name;
  final String key;
  final String navKey;
  final List<_ControllerInfo> children = [];
  final List<_PageInfo> pages;
  _ControllerInfo(RouterController controller)
      : name = controller.name,
        key = controller.key.toString(),
        navKey = controller.navKey.toString(),
        pages = controller.pages.map((e) => _PageInfo(e)).toList();

  Widget getWidget() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.teal.withOpacity(0.3),
        elevation: 5,
        child: Column(
            children: [
          const SizedBox(height: 10),
          Row(children: [
            const SizedBox(width: 10),
            Text('Name: $name'),
            const SizedBox(width: 5),
            Text('Key: $key'),
            const SizedBox(width: 5),
            Text('NavKey : $navKey'),
          ])
        ]
              ..addAll(pages.map((page) => Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Card(
                      color: Colors.teal.withOpacity(0.3),
                      elevation: 5,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Text('Name : ${page.name}'),
                          const SizedBox(width: 5),
                          Text('LocalKey: ${page.key}'),
                        ],
                      )))))
              ..addAll(children.map((e) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: e.getWidget(),
                  )))),
      ),
    );
  }
}

class _PageInfo {
  final String name;
  final String key;
  _PageInfo(QPage<dynamic> page)
      : name = page.name,
        key = page.matchKey.toString();
}
