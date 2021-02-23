import 'package:flutter/material.dart';
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
  final List<RouterController> _controllers;
  _StackTree(this._controllers);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _controllers
            .map((e) => Column(
                    children: [
                  Row(
                    children: [
                      Text('Name: ${e.name}'),
                      const SizedBox(width: 5),
                      Text('Key: ${e.key}'),
                      const SizedBox(width: 5),
                      Text('NavKey : ${e.navKey.hashCode}'),
                    ],
                  )
                ]..addAll(e.pages.map((page) => Row(
                          children: [
                            const SizedBox(width: 10),
                            Text('Name : ${page.name}'),
                            const SizedBox(width: 5),
                            Text('MatchKey: ${page.matchKey}'),
                            const SizedBox(width: 5),
                            Text('LocalKey: ${page.key}'),
                          ],
                        )))))
            .toList(),
      ),
    );
  }
}
