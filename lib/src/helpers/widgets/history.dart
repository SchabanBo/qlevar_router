import 'package:flutter/material.dart';

import '../../types/qhistory.dart';

// coverage:ignore-file
class DebugHistory extends StatelessWidget {
  final List<QHistoryEntry> history;
  const DebugHistory(this.history, {super.key});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (c) => AlertDialog(
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: history
                  .map(
                    (e) => Container(
                      color: Colors.teal.withAlpha(77),
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Text(e.navigator,
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          Text(e.key.toString(),
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          Text(e.path, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          Text(e.params.asStringMap().toString(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  )
                  .toList()),
          title: const Text('History:', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(),
              child: const Text('Close'),
            )
          ],
        ),
      ),
      child: const Text(
        'Show Navigation History',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
