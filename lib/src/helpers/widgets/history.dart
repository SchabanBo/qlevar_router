import 'package:flutter/material.dart';

import '../../types/qhistory.dart';

class DebugHistory extends StatelessWidget {
  final List<QHistoryEntry> history;
  DebugHistory(this.history);
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => showDialog(
            context: context,
            builder: (c) => AlertDialog(
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: history
                          .map((e) => Container(
                                color: Colors.teal.withOpacity(0.3),
                                margin: const EdgeInsets.all(5),
                                child: Row(children: [
                                  Text(e.navigator,
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 10),
                                  Text(e.path, style: TextStyle(fontSize: 16)),
                                ]),
                              ))
                          .toList()),
                  title: Text('History:', style: TextStyle(fontSize: 16)),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(c).pop(),
                        child: Text('Close'))
                  ],
                )),
        child: Text('Show Navigation History', style: TextStyle(fontSize: 16)));
  }
}
